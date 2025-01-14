import React, { ReactNode } from 'react';
import './container.scss';

interface Props {
  children: ReactNode;
}

export function Container({ children }: Props): JSX.Element {
  return <div className="container">{children}</div>;
}
