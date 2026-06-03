// app/javascript/controllers/predictions_keyboard_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["matchRow"]

  connect() {
    this.activeIndex = 0

    if (this.isLocked(this.matchRowTargets[this.activeIndex])) {
      this.move(1)
    } else {
      this.highlightActiveRow()
    }
  }

  handleKeydown(e) {
    if (!/^[0-5]$/.test(e.key)) return

    e.preventDefault();

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

  handleSaveTrigger(e) {
    e.preventDefault()
    const form = this.element.closest("form")
    if (form) {
      form.requestSubmit()
    }
  }

  handleBackwards(e) {
    this.move(-1)
  }

  handleForward(e) {
    this.move(1)
  }

  handleRowClick(e) {
    const clickedRow = e.target.closest('[data-predictions-keyboard-target="matchRow"]')
    if (!clickedRow || this.isLocked(clickedRow)) return

    const targetIndex = this.matchRowTargets.indexOf(clickedRow)

    if (targetIndex !== -1 && targetIndex !== this.activeIndex) {
      this.activeIndex = targetIndex
      this.highlightActiveRow(false)
    }
  }

  move(step) {
    let targetIndex = this.activeIndex
    const maxIndex = this.matchRowTargets.length - 1

    while (targetIndex + step >= 0 && targetIndex + step <= maxIndex) {
      targetIndex += step

      if (!this.isLocked(this.matchRowTargets[targetIndex])) {
        this.activeIndex = targetIndex
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