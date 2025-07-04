import './checkbox.scss';
import { ReactNode } from 'react';
import { Text } from '../text/text';
import { FormField, useInputId } from '../form_field/form_field';
import classnames from 'classnames';
import { FormError } from '../form_error/form_error';

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
          {label !== undefined && (
            <label
              className={classnames('checkbox__label', {
                'checkbox__label--disabled': disabled,
              })}
              htmlFor={inputId}
            >
              <Text>{label}</Text>
            </label>
          )}
        </div>
        <FormError touched={touched} errors={errors} />
      </div>
    </div>
  );
}
