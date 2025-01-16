import React, { ReactNode } from 'react';
import classNames from 'classnames';
import './pill.scss';

interface Props {
  children?: ReactNode;
  active?: boolean;
}

export function Pill({ children, active }: Props): JSX.Element {
  return (
    <div
      className={classNames('pill', 'pill-test', { 'pill--active': active })}
    >
      {children}
    </div>
  );
}
