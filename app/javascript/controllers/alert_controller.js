import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  static values = {
    dismissAfter: Number,
    removeDelay: Number
  }

  static classes = [ "show", "hide" ]

  connect() {
    // Add show classes when connected
    this.element.classList.add(...this.showClasses)

    // Start the dismiss timer
    if (this.hasDismissAfterValue) {
      this.dismissTimer = setTimeout(() => {
        this.close()
      }, this.dismissAfterValue)
    }
  }

  close() {
    // Clear the dismiss timer
    if (this.dismissTimer) {
      clearTimeout(this.dismissTimer)
    }

    // Add hide classes
    this.element.classList.remove(...this.showClasses)
    this.element.classList.add(...this.hideClasses)

    // Remove the element after animation
    setTimeout(() => {
      this.element.remove()
    }, this.removeDelayValue || 1000)
  }

  disconnect() {
    if (this.dismissTimer) {
      clearTimeout(this.dismissTimer)
    }
  }
}
