import { Controller } from '@hotwired/stimulus';

const SCRIPT_URL = 'https://assets.calendly.com/assets/external/widget.js';

declare global {
  interface Window {
    Calendly?: {
      initInlineWidget(options: {
        url: string;
        parentElement: HTMLElement;
        prefill?: { name?: string; email?: string };
      }): void;
    };
  }
}

function loadCalendly(): Promise<void> {
  if (window.Calendly) return Promise.resolve();
  return new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = SCRIPT_URL;
    script.onload = (): void => resolve();
    script.onerror = (): void => reject(new Error('Calendly failed to load'));
    document.head.append(script);
  });
}

export default class extends Controller<HTMLElement> {
  static targets = ['frame', 'form'];
  static values = { url: String, name: String, email: String };

  declare frameTarget: HTMLElement;
  declare formTarget: HTMLFormElement;
  declare urlValue: string;
  declare nameValue: string;
  declare emailValue: string;

  async connect(): Promise<void> {
    window.addEventListener('message', this.onMessage);
    await loadCalendly();
    window.Calendly?.initInlineWidget({
      url: this.urlValue,
      parentElement: this.frameTarget,
      prefill: { name: this.nameValue, email: this.emailValue },
    });
  }

  disconnect(): void {
    window.removeEventListener('message', this.onMessage);
  }

  private onMessage = (event: MessageEvent): void => {
    if (event.origin !== 'https://calendly.com') return;
    if (
      (event.data as { event?: string })?.event !== 'calendly.event_scheduled'
    )
      return;
    this.formTarget.requestSubmit();
  };
}
