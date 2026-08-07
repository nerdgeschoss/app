import { Controller } from '@hotwired/stimulus';

export default class extends Controller<HTMLElement> {
  private reset = (): void => this.collapse();

  connect(): void {
    document.addEventListener('turbo:before-cache', this.reset);
  }

  disconnect(): void {
    document.removeEventListener('turbo:before-cache', this.reset);
  }

  toggle(): void {
    this.element.classList.toggle('sidebar--expanded');
    this.syncAria();
  }

  private collapse(): void {
    this.element.classList.remove('sidebar--expanded');
    this.syncAria();
  }

  private syncAria(): void {
    const expanded = this.element.classList.contains('sidebar--expanded');
    this.element
      .querySelector('.sidebar__menu-toggle')
      ?.setAttribute('aria-expanded', String(expanded));
  }
}
