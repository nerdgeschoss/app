import React, { ReactNode } from 'react';

interface Props {
  children: ReactNode;
  onSubmit?: () => void;
}

export function Form({ children, onSubmit }: Props): JSX.Element {
  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        onSubmit?.();
      }}
    >
      {children}
    </form>
  );
}
