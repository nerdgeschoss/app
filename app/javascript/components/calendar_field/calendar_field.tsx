import React, { ReactNode, useEffect, useRef } from 'react';

import { Text } from '../text/text';
import { FormField } from '../form_field/form_field';
import classnames from 'classnames';
import Flatpickr from 'react-flatpickr';

interface Props extends FormField<Date[]> {
  label?: ReactNode;
}

export function CalendarField({
  name,
  value,
  ariaLabel,
  placeholder,
  required,
  disabled,
  readOnly,
  inputId,
  label,
  touched,
  errors,
  onChange,
  onBlur,
  onFocus,
}: Props): JSX.Element {
  return (
    <div className="calendar-field">
      <Flatpickr
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
