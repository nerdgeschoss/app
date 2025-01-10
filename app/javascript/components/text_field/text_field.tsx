import React, { ReactNode } from 'react';

import { Text } from '../text/text';
import { FormField, useInputId } from '../form_field/form_field';
import classnames from 'classnames';
import './text_field.scss';

interface Props extends FormField<string | null> {
  label?: ReactNode;
}

export function TextField({
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
  inputId = useInputId(inputId);
  return (
    <div className="text-field__container">
      <div
        className={classnames(
          'text-field',
          {
            'text-field--filled': !!value,
            'text-field--readonly': readOnly,
            'text-field--disabled': disabled,
            'text-field--placeholder': placeholder,
          },
          { disabled }
        )}
      >
        <div className="text-field__content">
          {label !== undefined && (
            <label
              className={classnames('text-field__label', {
                'text-field__label--disabled': disabled,
              })}
              htmlFor={inputId}
            >
              {label}
            </label>
          )}
          <Text>
            <input
              id={inputId}
              name={name}
              className={classnames('text-field__input')}
              readOnly={readOnly}
              value={value ?? ''}
              type="text"
              onChange={(event) => {
                if (readOnly) {
                  event.preventDefault();
                  return;
                }
                onChange?.(event.target.value);
              }}
              onFocus={() => {
                onFocus?.();
              }}
              onBlur={() => {
                onBlur?.();
              }}
              placeholder={placeholder}
              required={required}
              disabled={disabled}
              aria-label={ariaLabel}
            />
          </Text>
        </div>
        {touched && errors && (
          <div className="text-field__errors">
            {errors.map((error) => (
              <Text key={error}>{error}</Text>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
