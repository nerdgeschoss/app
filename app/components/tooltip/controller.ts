import { Controller } from '@hotwired/stimulus';

export default class extends Controller<HTMLElement> {
  static targets = ['anchor'];

  declare readonly anchorTarget: HTMLElement;
  declare readonly hasAnchorTarget: boolean;

  // Captured once: Stimulus looks up targets scoped to `this.element`, but
  // connect() moves the anchor to <body>, so it can no longer find it afterwards.
  private anchor: HTMLElement | null = null;

  private readonly show = (): void => this.position();
  private readonly hide = (): void =>
    this.anchor?.classList.remove('tooltip__anchor--visible');

  connect(): void {
    if (!this.hasAnchorTarget) return;
    this.anchor = this.anchorTarget;
    document.body.appendChild(this.anchor);
    this.element.addEventListener('mouseenter', this.show);
    this.element.addEventListener('mouseleave', this.hide);
  }

  disconnect(): void {
    if (!this.anchor) return;
    this.element.removeEventListener('mouseenter', this.show);
    this.element.removeEventListener('mouseleave', this.hide);
    this.anchor.remove();
    this.anchor = null;
  }

  private position(): void {
    if (!this.anchor) return;
    const rect = this.element.getBoundingClientRect();
    this.anchor.style.top = `${rect.top + rect.height / 2}px`;
    this.anchor.style.left = `${rect.right}px`;
    this.anchor.classList.add('tooltip__anchor--visible');
  }
}
