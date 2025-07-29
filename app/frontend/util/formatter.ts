import { sameDay } from './date';
import type { Locale } from './i18n';

export class Formatter {
  readonly locale: Locale;

  constructor({ locale }: { locale: Formatter['locale'] }) {
    this.locale = locale;
  }

  currency(value: number | string): string {
    return new Intl.NumberFormat(this.locale, {
      style: 'currency',
      currency: 'EUR',
    }).format(Number(value));
  }

  singleDigitNumber(value: number): string {
    return new Intl.NumberFormat(this.locale, {
      minimumFractionDigits: 1,
      maximumFractionDigits: 1,
    }).format(value);
  }

  hours(value: number | string): string {
    const numValue = Number(value);
    const hours = Math.floor(numValue);
    const minutes = Math.round((numValue - hours) * 60);
    return `${hours}:${minutes.toString().padStart(2, '0')}`;
  }

  date(value: Date | string): string | null {
    const date = this.parseDate(value);

    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      month: '2-digit',
      day: '2-digit',
      year: 'numeric',
    }).format(date);
  }

  dayName(value: Date | string): string | null {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      weekday: 'long',
    }).format(date);
  }

  monthAndYear(value: Date | string): string | null {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      month: 'long',
      year: 'numeric',
    }).format(date);
  }

  time(value: Date | string): string | null {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      hour: '2-digit',
      minute: '2-digit',
    }).format(date);
  }

  datetime(value: Date | string): string | null {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    const options: Intl.DateTimeFormatOptions = {
      hour: '2-digit',
      minute: '2-digit',
      weekday: 'long',
    };
    // if the date was more than 1 week ago
    if (date.getTime() < Date.now() - 7 * 24 * 60 * 60 * 1000) {
      Object.assign(options, {
        month: '2-digit',
        day: '2-digit',
        year: 'numeric',
      });
    } else {
      Object.assign(options, { weekday: 'long' });
    }

    return new Intl.DateTimeFormat(this.locale, options).format(date);
  }

  dateLongMonth(value: Date | string): string | null {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      month: 'long',
      day: 'numeric',
      year: 'numeric',
    }).format(date);
  }

  narrowWeek(value: Date | string): string | null {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      weekday: 'narrow',
    }).format(date);
  }

  dateLongNoYear(value: Date | string) {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      month: 'long',
      day: 'numeric',
    }).format(date);
  }

  dateNoYear(value: Date | string) {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      month: '2-digit',
      day: 'numeric',
    }).format(date);
  }

  dateRangeLong(start: Date | string, end: Date | string): string | null {
    const startDate = this.parseDate(start);
    const endDate = this.parseDate(end);
    if (!startDate || !endDate) {
      return null;
    }
    if (sameDay(startDate, endDate)) {
      return this.date(startDate);
    }
    if (startDate.getFullYear() === endDate.getFullYear()) {
      return `${this.dateLongNoYear(startDate)} - ${this.dateLongMonth(endDate)}`;
    } else {
      return `${this.dateLongMonth(startDate)} - ${this.dateLongMonth(endDate)}`;
    }
  }

  dateRange(start: Date | string, end: Date | string): string | null {
    const startDate = this.parseDate(start);
    const endDate = this.parseDate(end);
    if (!startDate || !endDate) {
      return null;
    }
    if (sameDay(startDate, endDate)) {
      return this.date(startDate);
    }
    if (startDate.getFullYear() === endDate.getFullYear()) {
      return `${this.dateNoYear(startDate)} - ${this.date(endDate)}`;
    } else {
      return `${this.date(startDate)} - ${this.date(endDate)}`;
    }
  }

  parseDate(value?: string | Date | null): Date | null {
    if (!value) {
      return null;
    }
    if (typeof value !== 'string') {
      return value;
    }
    const unix = Date.parse(value);
    if (isNaN(unix)) {
      return null;
    }
    return new Date(unix);
  }

  parseRequiredDate(value: string | Date | null): Date {
    const date = this.parseDate(value);
    if (!date) {
      throw new Error('Invalid date');
    }
    return date;
  }

  percentage(value: number): string {
    return new Intl.NumberFormat(this.locale, {
      style: 'percent',
      maximumFractionDigits: 0,
      minimumFractionDigits: 0,
    }).format(value);
  }
}
