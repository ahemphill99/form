import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:before-render", (event) => {
      event.preventDefault()
      
      const newFrame = event.detail.newFrame
      newFrame.classList.add("translate-x-full")
      
      Promise.resolve()
        .then(() => {
          this.element.classList.add("-translate-x-full", "transition-transform", "duration-500", "ease-in-out")
          newFrame.classList.add("transition-transform", "duration-500", "ease-in-out")
          return new Promise(resolve => setTimeout(resolve, 50))
        })
        .then(() => {
          newFrame.classList.remove("translate-x-full")
          return new Promise(resolve => setTimeout(resolve, 500))
        })
        .then(() => {
          event.detail.resume()
        })
    })
  }
}
