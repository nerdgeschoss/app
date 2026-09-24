import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { modalUrl: String };
  declare modalUrlValue: string;

  openModal(event: Event): void {
    event.preventDefault();
    void window.ui?.modal.open({ url: this.modalUrlValue });
    // Shimmer adds these to <body>; a Turbo refresh morph would remove them and close the modal.
    document
      .querySelectorAll('body > .modal, body > .modal-blind, #shimmer')
      .forEach((element) => element.setAttribute('data-turbo-permanent', ''));
  }
}
