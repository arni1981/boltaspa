// app/javascript/controllers/mobile_menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  // Use a disconnect to ensure the body isn't locked if the user navigates away
  disconnect() {
    this.close()
  }

  toggle() {
    this.sidebarTarget.classList.contains("-translate-x-full") ? this.open() : this.close()
  }

  open() {
    this.sidebarTarget.classList.replace("-translate-x-full", "translate-x-0")
    this.overlayTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden" // Pro: Hard lock the scroll
  }

  close() {
    this.sidebarTarget.classList.replace("translate-x-0", "-translate-x-full")
    this.overlayTarget.classList.add("hidden")
    document.body.style.overflow = "" // Pro: Restore scroll
  }
}