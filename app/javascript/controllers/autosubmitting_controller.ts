import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="autosubmitting"
export default class extends Controller {
  connect(): void {
    this.#el.addEventListener('change', this.#change);
  }

  disconnect(): void {
    this.#el.removeEventListener('change', this.#change);
  }

  #change: () => void = () => {
    this.#el.form?.requestSubmit();
  };

  get #el(): HTMLInputElement {
    return this.element as HTMLInputElement;
  }
}
