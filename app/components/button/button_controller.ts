import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { url: String };

  declare urlValue: string;

  openModal(): void {
    window.ui?.modal.open({ url: this.urlValue });
  }
}
