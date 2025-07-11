import React from 'react';
import { Text } from '../text/text';
import './button.scss';

interface Props {
  title: string;
  disabled?: boolean;
  disablePreventDefault?: boolean;
  onClick?: () => void;
}

export function Button({
  title,
  disabled,
  disablePreventDefault,
  onClick,
}: Props): JSX.Element {
  return (
    <button
      className="button"
      onClick={(event) => {
        if (!disablePreventDefault) {
          event.preventDefault();
        }
        if (disabled) return;
        onClick?.();
      }}
      disabled={disabled}
    >
      <Text>{title}</Text>
    </button>
  );
}
