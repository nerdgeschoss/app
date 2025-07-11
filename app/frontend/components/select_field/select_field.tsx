import './select_field.scss';
import { ReactNode } from 'react';
import { Text } from '../text/text';
import { FormField, SelectOption, useInputId } from '../form_field/form_field';
import classnames from 'classnames';
import { FormError } from '../form_error/form_error';

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
  inputId = useInputId(inputId);
  return (
    <div className="select-field__container">
      <div
        className={classnames(
          'select-field',
          {
            'select-field--filled': !!value,
            'select-field--readonly': readOnly,
            'select-field--disabled': disabled,
            'select-field--placeholder': placeholder,
          },
          { disabled }
        )}
      >
        <div className="select-field__content">
          {label !== undefined && (
            <label
              className={classnames('select-field__label', {
                'select-field__label--disabled': disabled,
              })}
              htmlFor={inputId}
            >
              <Text type="label-heading-primary" color="label-heading-primary">
                {label}
              </Text>
            </label>
          )}
          <Text block>
            <select
              id={inputId}
              name={name}
              className={classnames('select-field__input')}
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
        <FormError touched={touched} errors={errors} />
      </div>
    </div>
  );
}
