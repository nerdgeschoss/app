import { ReactNode } from 'react';
import { Text } from '../text/text';
import classnames from 'classnames';
import { FormField, useInputId } from '../form_field/form_field';
import './star_field.scss';

interface Props extends FormField<number> {
  label?: ReactNode;
}

export function StarField({
  value,
  name,
  label,
  disabled,
  inputId,
  onChange,
}: Props): JSX.Element {
  inputId = useInputId(inputId);

  return (
    <div className="star-field">
      {label && (
        <div
          className={classnames('star-field__label', {
            'star-field__label--disabled': disabled,
          })}
        >
          <Text type="label-heading-primary" color="label-heading-primary">
            {label}
          </Text>
        </div>
      )}
      <div className="star-field__stars">
        {[1, 2, 3, 4, 5].map((star) => (
          <div
            className={classnames('star-field__star', {
              'star-field__star--active': star <= value,
            })}
            key={star}
          >
            <label htmlFor={inputId ? `${inputId}-${star}` : undefined}>
              <input
                id={inputId ? `${inputId}-${star}` : undefined}
                name={name}
                className={classnames('star-field__input')}
                type="radio"
                disabled={disabled}´
                value={star}
                checked={star <= value}
                onClick={() => {
                  onChange?.(star);
                }}
              />
              <span>⭐</span>
            </label>
          </div>
        ))}
      </div>
    </div>
  );
}
