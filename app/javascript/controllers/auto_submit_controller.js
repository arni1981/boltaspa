import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-submit"
export default class extends Controller {
  submit() {
    this.element.requestSubmit()
  }

  // @todo: Move to a dedicated controller
  pulse(event) {
    const { success, response } = event.detail

    if (success) {
      const row = this.element.querySelector('.match-row')
      row.classList.add("is-success-pulse")
      row.addEventListener('animationend', () => {
        row.classList.remove("is-success-pulse")
      }, { once: true })
    } else {
      // The served will handle this by issueing a redirect
    }
  }
}
