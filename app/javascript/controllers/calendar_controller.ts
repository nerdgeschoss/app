import { Controller } from '@hotwired/stimulus';
import flatpickr from 'flatpickr';

export default class extends Controller {
  private instance?: flatpickr.Instance;

  connect(): void {
    this.instance = flatpickr(this.element, {
      inline: true,
      mode: 'multiple',
      disable: [(date) => date.getDay() === 0 || date.getDay() === 6],
      weekNumbers: true,
      locale: {
        firstDayOfWeek: 1,
      },
    });
  }

  disconnect(): void {
    this.instance?.destroy();
  }
}
