// app/javascript/controllers/predictions_keyboard_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["matchRow"]

  connect() {
    this.activeIndex = 0

    if (this.isLocked(this.matchRowTargets[this.activeIndex])) {
      this.advanceRowSequentially()
    } else {
      this.highlightActiveRow()
    }
  }

  handleKeydown(e) {
    if (!/^[0-5]$/.test(e.key)) return

    const currentRow = this.matchRowTargets[this.activeIndex]
    if (!currentRow || this.isLocked(currentRow)) return

    const scoreValue = e.key

    const checkedHome = currentRow.querySelector('input[name$="[home_guess]"]:checked')
    const checkedAway = currentRow.querySelector('input[name$="[away_guess]"]:checked')

    if (!checkedHome || (checkedHome && checkedAway)) {
      this.selectRadio(currentRow, "home_guess", scoreValue)
      if (checkedAway) this.clearRadioGroup(currentRow, "away_guess")
    } else {
      this.selectRadio(currentRow, "away_guess", scoreValue)
    }
  }

  // Force-saves the full form via Enter or Ctrl+S keys
  handleSaveTrigger(e) {
    const form = this.element.closest("form")
    if (form) {
      form.requestSubmit()
    }
  }

  handleBackwards(e) {
    this.regressRowSequentially()
  }

  handleForward(e) {
    this.advanceRowSequentially()
  }

  handleRowClick(e) {
    const clickedRow = e.target.closest('[data-predictions-keyboard-target="matchRow"]')
    if (!clickedRow || this.isLocked(clickedRow)) return

    const targetIndex = this.matchRowTargets[this.activeIndex] === clickedRow ? -1 : this.matchRowTargets.indexOf(clickedRow)

    if (targetIndex !== -1) {
      this.activeIndex = targetIndex
      this.highlightActiveRow(false)
    }
  }

  advanceRowSequentially() {
    let nextIndex = this.activeIndex
    while (nextIndex < this.matchRowTargets.length - 1) {
      nextIndex++
      if (!this.isLocked(this.matchRowTargets[nextIndex])) {
        this.activeIndex = nextIndex
        this.highlightActiveRow()
        return
      }
    }
  }

  regressRowSequentially() {
    let prevIndex = this.activeIndex
    while (prevIndex > 0) {
      prevIndex--
      if (!this.isLocked(this.matchRowTargets[prevIndex])) {
        this.activeIndex = prevIndex
        this.highlightActiveRow()
        return
      }
    }
  }

  selectRadio(container, pattern, value) {
    const radio = container.querySelector(`input[name$="[${pattern}]"][value="${value}"]`)
    if (radio && !radio.disabled) {
      radio.click()
    }
  }

  clearRadioGroup(container, pattern) {
    container.querySelectorAll(`input[name$="[${pattern}]"]`).forEach(radio => {
      if (radio.checked) {
        radio.checked = false
        radio.dispatchEvent(new Event("change", { bubbles: true }))
      }
    })
  }

  highlightActiveRow(scrollIntoView = true) {
    this.matchRowTargets.forEach((row, idx) => {
      if (idx === this.activeIndex) {
        row.classList.add("ring-2", "ring-[#2d5a43]", "border-[#2d5a43]")

        if (scrollIntoView) {
          row.scrollIntoView({ behavior: "smooth", block: "center" })
        }
      } else {
        row.classList.remove("ring-2", "ring-[#2d5a43]", "border-[#2d5a43]")
      }
    })
  }

  isLocked(row) {
    if (!row) return true
    return row.dataset.predictable === "false"
  }
}