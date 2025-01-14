import React, { ReactNode } from 'react';

import { Text } from '../text/text';
import { FormField, useInputId } from '../form_field/form_field';
import classnames from 'classnames';
import './checkbox.scss';

interface Props extends FormField<boolean> {
  label?: ReactNode;
}

export function Checkbox({
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
    <div className="checkbox__container">
      <div
        className={classnames(
          'checkbox',
          {
            'checkbox--filled': !!value,
            'checkbox--readonly': readOnly,
            'checkbox--disabled': disabled,
            'checkbox--placeholder': placeholder,
          },
          { disabled }
        )}
      >
        <div className="checkbox__content">
          {label !== undefined && (
            <label
              className={classnames('checkbox__label', {
                'checkbox__label--disabled': disabled,
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
              className={classnames('checkbox__input')}
              readOnly={readOnly}
              checked={value}
              type="checkbox"
              onChange={(event) => {
                if (readOnly) {
                  event.preventDefault();
                  return;
                }
                onChange?.(event.target.checked);
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
          <div className="checkbox__errors">
            {errors.map((error) => (
              <Text key={error}>{error}</Text>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
