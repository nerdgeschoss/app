import React, { ReactNode } from 'react';

import { FormField } from '../form_field/form_field';
import DatePicker from 'react-flatpickr';

interface Props extends FormField<Date[]> {
  label?: ReactNode;
}

export function CalendarField({ value, onChange }: Props): JSX.Element {
  return (
    <div className="calendar-field">
      <DatePicker
        value={value}
        options={{
          inline: true,
          mode: 'multiple',
          disable: [(date) => date.getDay() === 0 || date.getDay() === 6],
          weekNumbers: true,
          locale: {
            firstDayOfWeek: 1,
          },
        }}
        onChange={(value) => {
          onChange?.(value.sort((a, b) => a.getTime() - b.getTime()));
        }}
        className="calendar-field__input"
      />
    </div>
  );
}
