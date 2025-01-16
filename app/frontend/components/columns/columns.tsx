import React, { ReactNode } from 'react';
import './columns.scss';

interface Props {
  children?: ReactNode;
}

export function Columns({ children }: Props): JSX.Element {
  return <div className="columns">{children}</div>;
}
