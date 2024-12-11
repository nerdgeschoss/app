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

  dateWithoutYear(value: Date | string): string | null {
    const date = this.parseDate(value);
    if (!date) {
      return null;
    }
    return new Intl.DateTimeFormat(this.locale, {
      month: '2-digit',
      day: '2-digit',
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

  dateRange(start: Date | string, end: Date | string): string | null {
    const startDate = this.parseDate(start);
    const endDate = this.parseDate(end);
    if (!startDate || !endDate) {
      return null;
    }
    if (startDate.getFullYear() === endDate.getFullYear()) {
      return `${this.dateWithoutYear(startDate)} - ${this.date(endDate)}`;
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

  percentage(value: number): string {
    return new Intl.NumberFormat(this.locale, {
      style: 'percent',
      maximumFractionDigits: 0,
      minimumFractionDigits: 0,
    }).format(value);
  }
}
