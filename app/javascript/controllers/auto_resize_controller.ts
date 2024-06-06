import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect(): void {
    this.#el.style.overflowY = 'hidden';
    this.update();
  }

  update(): void {
    this.#el.style.height = 'auto';
    this.#el.style.height = this.#el.scrollHeight + 'px';
  }

  get #el(): HTMLInputElement {
    return this.element as HTMLInputElement;
  }
}
