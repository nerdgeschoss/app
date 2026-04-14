import { Controller } from '@hotwired/stimulus';
import flatpickr from 'flatpickr';
import { Instance } from 'flatpickr/dist/types/instance';

export default class extends Controller {
  static targets = ['picker', 'inputs', 'warning'];
  static values = { name: String };

  declare pickerTarget: HTMLElement;
  declare inputsTarget: HTMLElement;
  declare warningTarget: HTMLElement;
  declare nameValue: string;

  private fp: Instance | null = null;

  connect(): void {
    this.fp = flatpickr(this.pickerTarget, {
      inline: true,
      mode: 'multiple',
      weekNumbers: true,
      disable: [(date) => date.getDay() === 0 || date.getDay() === 6],
      locale: { firstDayOfWeek: 1 },
      onChange: (_dates, _dateStr, _instance) => {
        this.updateInputs(_dates);
        this.updateWarning(_dates);
      },
    });
  }

  disconnect(): void {
    this.fp?.destroy();
  }

  private updateInputs(dates: Date[]): void {
    this.inputsTarget.innerHTML = '';
    dates
      .sort((a, b) => a.getTime() - b.getTime())
      .forEach((date) => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = this.nameValue;
        input.value = this.formatDate(date);
        this.inputsTarget.appendChild(input);
      });
  }

  private updateWarning(dates: Date[]): void {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const hasPast = dates.some((date) => {
      const d = new Date(date);
      d.setHours(0, 0, 0, 0);
      return d < today;
    });
    this.warningTarget.style.display = hasPast ? '' : 'none';
  }

  private formatDate(date: Date): string {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}-${m}-${d}`;
  }
}
