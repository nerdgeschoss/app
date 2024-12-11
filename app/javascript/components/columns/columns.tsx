import React, { ReactNode } from 'react';

interface Props {
  children?: ReactNode;
}

export function Columns({ children }: Props): JSX.Element {
  return <div className="columns">{children}</div>;
}
