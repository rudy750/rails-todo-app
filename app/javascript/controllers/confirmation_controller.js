import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirmation"
export default class extends Controller {
  static targets = ["trigger", "options"]

  confirm(event) {
    event.preventDefault()
    this.triggerTarget.classList.add("d-none")
    this.optionsTarget.classList.remove("d-none")
    this.optionsTarget.classList.add("d-flex")
  }

  cancel(event) {
    event.preventDefault()
    this.optionsTarget.classList.add("d-none")
    this.optionsTarget.classList.remove("d-flex")
    this.triggerTarget.classList.remove("d-none")
  }
}
