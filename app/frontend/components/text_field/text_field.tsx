import React, { ReactNode } from 'react';
import { Collapse } from '@nerdgeschoss/shimmer-component-collapse';
import { Text } from '../text/text';
import { FormField, useInputId } from '../form_field/form_field';
import classnames from 'classnames';
import './text_field.scss';
import { Spacer } from '../spacer/spacer';
import { useTranslate } from '../../util/dependencies';
import { getErrorMessage } from '../../util/errors';

interface Props extends FormField<string> {
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
  const t = useTranslate();

  inputId = useInputId(inputId);
  return (
    <div className="text-field__container">
      <div
        className={classnames('text-field', {
          'text-field--filled': !!value,
          'text-field--readonly': readOnly,
          'text-field--disabled': disabled,
          'text-field--placeholder': placeholder,
        })}
      >
        <div className="text-field__content">
          {label !== undefined && (
            <label
              className={classnames('text-field__label', {
                'text-field__label--disabled': disabled,
              })}
              htmlFor={inputId}
            >
              <Text type="label-heading-primary" color="label-heading-primary">
                {label}
              </Text>
            </label>
          )}
          <Text block color={disabled ? 'label-heading-secondary' : undefined}>
            <input
              id={inputId}
              name={name}
              className="text-field__input"
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
        <Collapse open={touched && !!errors?.length}>
          <Spacer size={8} />
          <div className="text-field__errors">
            {errors?.map((error) => (
              <Text key={error}>{t(getErrorMessage(error))}</Text>
            ))}
          </div>
        </Collapse>
      </div>
    </div>
  );
}
