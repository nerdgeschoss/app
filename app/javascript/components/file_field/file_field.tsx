import React, { ReactNode } from 'react';

import { Text } from '../text/text';
import { FormField, SelectOption } from '../form_field/form_field';
import classnames from 'classnames';

interface Props extends FormField<File | null> {
  label?: ReactNode;
}

export function FileField({
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
  valid,
  errors,
  onChange,
  onBlur,
  onFocus,
}: Props): JSX.Element {
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
            <input
              id={inputId}
              name={name}
              type="file"
              className={classnames('textfield__input')}
              onChange={(event) => {
                if (event.target.files) {
                  onChange?.(Array.from(event.target.files)[0] ?? null);
                }
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
            />
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