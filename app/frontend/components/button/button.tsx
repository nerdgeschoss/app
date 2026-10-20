import classnames from 'classnames';
import { JSX } from 'react';
import { Text } from '../text/text';
import './button.scss';

interface Props {
  title: string;
  variant?: 'primary' | 'secondary' | 'icon';
  tone?: 'default' | 'success' | 'error';
  disabled?: boolean;
  disablePreventDefault?: boolean;
  ariaLabel?: string;
  onClick?: () => void;
}

export function Button({
  title,
  variant = 'primary',
  tone = 'default',
  disabled,
  disablePreventDefault,
  ariaLabel,
  onClick,
}: Props): JSX.Element {
  return (
    <button
      className={classnames('button', {
        [`button--${variant}`]: variant !== 'primary',
        [`button--tone-${tone}`]: tone !== 'default',
        'button--disabled': disabled,
      })}
      onClick={(event) => {
        if (!disablePreventDefault) {
          event.preventDefault();
        }
        if (disabled) return;
        onClick?.();
      }}
      disabled={disabled}
      aria-label={ariaLabel}
    >
      <Text>{title}</Text>
    </button>
  );
}
