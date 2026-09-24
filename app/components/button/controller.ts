import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { modalUrl: String };
  declare modalUrlValue: string;

  openModal(event: Event): void {
    event.preventDefault();
    void window.ui?.modal.open({ url: this.modalUrlValue });
  }
}
