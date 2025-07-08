import './text_field.scss';
import { ReactNode } from 'react';
import { Text } from '../text/text';
import { FormField, useInputId } from '../form_field/form_field';
import classnames from 'classnames';
import { FormError } from '../form_error/form_error';

interface Props extends FormField<string> {
  label?: ReactNode;
  autoComplete?: string;
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
  autoComplete,
  onChange,
  onBlur,
  onFocus,
}: Props): JSX.Element {
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
              autoComplete={autoComplete}
            />
          </Text>
        </div>
        <FormError touched={touched} errors={errors} />
      </div>
    </div>
  );
}
