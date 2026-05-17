import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-submit"
export default class extends Controller {
  static targets = ['row']
  static classes = ['success']

  submit() {
    this.element.requestSubmit()
  }

  pulse(event) {
    const { success } = event.detail

    if (success) {
      // 1. Strip the class immediately in case it's already there from a fast previous click
      this.rowTarget.classList.remove(this.successClass)

      // 2. Force a browser reflow (the magical trick to reset CSS animations)
      void this.rowTarget.offsetWidth

      // 3. Add it back cleanly to re-trigger the keyframes from 0%
      this.rowTarget.classList.add(this.successClass)

      this.rowTarget.addEventListener('animationend',
        () => this.rowTarget.classList.remove(this.successClass), { once: true }
      )
    }
  }
}
