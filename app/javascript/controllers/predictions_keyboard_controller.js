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

    e.preventDefault()
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

  handleNavigation(e) {
    if (e.key === "Backspace") {
      const currentRow = this.matchRowTargets[this.activeIndex]
      if (!currentRow) return

      const checkedHome = currentRow.querySelector('input[name$="[home_guess]"]:checked')
      const checkedAway = currentRow.querySelector('input[name$="[away_guess]"]:checked')

      if (checkedAway) {
        e.preventDefault()
        this.clearRadioGroup(currentRow, "away_guess")
      } else if (checkedHome) {
        e.preventDefault()
        this.clearRadioGroup(currentRow, "home_guess")
      } else {
        e.preventDefault()
        this.regressRowSequentially()
      }
      return
    }

    if (e.key === "ArrowDown" || e.key === "ArrowRight") {
      e.preventDefault()
      this.advanceRowSequentially()
    }

    if (e.key === "ArrowUp" || e.key === "ArrowLeft") {
      e.preventDefault()
      this.regressRowSequentially()
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
      radio.checked = true
      radio.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }

  clearRadioGroup(container, pattern) {
    container.querySelectorAll(`input[name$="[${pattern}]"]`).forEach(radio => {
      radio.checked = false
      radio.dispatchEvent(new Event("change", { bubbles: true }))
    })
  }

  highlightActiveRow() {
    this.matchRowTargets.forEach((row, idx) => {
      if (idx === this.activeIndex) {
        row.classList.add("ring-2", "ring-[#2d5a43]", "border-[#2d5a43]")
        row.scrollIntoView({ behavior: "smooth", block: "center" })
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