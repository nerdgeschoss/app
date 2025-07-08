import React, { ReactNode } from 'react';

import './text_area.scss';
import { Text } from '../text/text';
import { FormField, useInputId } from '../form_field/form_field';
import classnames from 'classnames';
import { FormError } from '../form_error/form_error';

interface Props extends FormField<string> {
  label?: ReactNode;
}

export function TextArea({
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
    <Text block color={disabled ? 'label-heading-secondary' : undefined}>
      <div className="text-area__container">
        <div
          className={classnames(
            'text-area',
            {
              'text-area--filled': !!value,
              'text-area--readonly': readOnly,
              'text-area--disabled': disabled,
              'text-area--placeholder': placeholder,
            },
            { disabled }
          )}
        >
          <div className="text-area__content">
            {label !== undefined && (
              <label
                className={classnames('text-area__label', {
                  'text-area__label--disabled': disabled,
                })}
                htmlFor={inputId}
              >
                <Text
                  type="label-heading-primary"
                  color="label-heading-primary"
                >
                  {label}
                </Text>
              </label>
            )}
            <div
              className="text-area__input-wrapper"
              data-replicated-value={value}
            >
              <textarea
                id={inputId}
                name={name}
                className={classnames('text-area__input')}
                readOnly={readOnly}
                value={value ?? ''}
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
            </div>
          </div>
          <FormError touched={touched} errors={errors} />
        </div>
      </div>
    </Text>
  );
}
