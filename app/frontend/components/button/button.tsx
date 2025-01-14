import React from 'react';

interface Props {
  title: string;
  disabled?: boolean;
  onClick?: () => void;
}

export function Button({ title, disabled, onClick }: Props): JSX.Element {
  return (
    <button
      className="button"
      onClick={(event) => {
        event.preventDefault();
        if (disabled) return;
        onClick?.();
      }}
      disabled={disabled}
    >
      {title}
    </button>
  );
}
