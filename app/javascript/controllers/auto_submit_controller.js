import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-submit"
export default class extends Controller {
  submit(event) {
    if (this.#isSavingData || this.#hasSlowInternet) {
      return
    }

    this.element.requestSubmit()
  }

  #isSavingData() {
    return navigator.connection?.saveData
  }

  #hasSlowInternet() {
    return navigator.connection?.effectiveType === "slow-2g" ||
      navigator.connection?.effectiveType === "2g" ||
      navigator.connection?.effectiveType === "3g"
  }
}
