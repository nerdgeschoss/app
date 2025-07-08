import React, { ReactNode } from 'react';

import { FormField, useInputId } from '../form_field/form_field';
import DatePickerImport, { DateTimePickerProps } from 'react-flatpickr';
import './calendar-field.scss';
import 'flatpickr/dist/flatpickr.min.css';
import { FormError } from '../form_error/form_error';
import classnames from 'classnames';
import { Text } from '../text/text';

interface Props extends FormField<Date[]> {
  label?: ReactNode;
}

// workaround for the type error in the flatpickr package
const DatePicker = DatePickerImport as unknown as (
  props: DateTimePickerProps
) => JSX.Element;

export function CalendarField({
  label,
  value,
  touched,
  errors,
  disabled,
  inputId,
  name,
  onChange,
}: Props): JSX.Element {
  inputId = useInputId(inputId);

  return (
    <div className="calendar-field">
      {label !== undefined && (
        <label
          className={classnames('calendar-field__label', {
            'calendar-field__label--disabled': disabled,
          })}
          htmlFor={inputId}
        >
          <Text type="label-heading-primary" color="label-heading-primary">
            {label}
          </Text>
        </label>
      )}
      <DatePicker
        id={inputId}
        name={name}
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
      <FormError touched={touched} errors={errors} />
    </div>
  );
}
