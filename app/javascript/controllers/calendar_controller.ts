import { Controller } from '@hotwired/stimulus';
import flatpickr from 'flatpickr';

export default class extends Controller {
  static targets = ['input', 'pastWarning'];

  private instance?: flatpickr.Instance;
  declare readonly inputTarget: HTMLTextAreaElement;
  declare readonly pastWarningTarget: HTMLDivElement;

  connect(): void {
    this.handleWarning = this.handleWarning.bind(this);

    this.instance = flatpickr(this.inputTarget, {
      inline: true,
      mode: 'multiple',
      disable: [(date) => date.getDay() === 0 || date.getDay() === 6],
      weekNumbers: true,
      locale: {
        firstDayOfWeek: 1,
      },
      onReady: this.handleWarning,
      onChange: this.handleWarning,
    });
  }

  handleWarning(selectedDates: Date[]): void {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const showWarning = selectedDates.some((date) => date < today);
    this.pastWarningTarget.hidden = !showWarning;
  }

  disconnect(): void {
    this.instance?.destroy();
  }
}
