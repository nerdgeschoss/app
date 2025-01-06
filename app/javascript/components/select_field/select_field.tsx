import React, { ReactNode } from 'react';

import { Text } from '../text/text';
import { FormField, SelectOption } from '../form_field/form_field';
import classnames from 'classnames';

interface Props<T extends string> extends FormField<T> {
  label?: ReactNode;
  options: SelectOption<T>[];
}

export function SelectField<T extends string>({
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
  options,
}: Props<T>): JSX.Element {
  return (
    <div className="textfield__container">
      <div
        className={classnames(
          'textfield',
          {
            'textfield--filled': !!value,
            'textfield--readonly': readOnly,
            'textfield--disabled': disabled,
            'textfield--placeholder': placeholder,
          },
          { disabled }
        )}
      >
        <div className="textfield__content">
          {label !== undefined && (
            <label
              className={classnames('textfield__label', {
                'textfield__label--disabled': disabled,
              })}
              htmlFor={inputId}
            >
              <Text>{label}</Text>
            </label>
          )}
          <Text>
            <select
              id={inputId}
              name={name}
              className={classnames('textfield__input')}
              value={value ?? ''}
              onChange={(event) => {
                if (readOnly) {
                  event.preventDefault();
                  return;
                }
                onChange?.(event.target.value as T);
              }}
              onFocus={() => {
                onFocus?.();
              }}
              onBlur={() => {
                onBlur?.();
              }}
              required={required}
              disabled={disabled}
              aria-label={ariaLabel}
            >
              {options.map((option) => (
                <option key={option.value} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
          </Text>
        </div>
        {touched && errors && (
          <div className="textfield__errors">
            {errors.map((error) => (
              <Text key={error}>{error}</Text>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
