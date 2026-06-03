import './table.scss';
import React, { JSX } from 'react';
import classNames from 'classnames';

interface Props {
  children: React.ReactNode;
  className?: string;
}

export function Table({ children, className }: Props): JSX.Element {
  return <table className={classNames('table', className)}>{children}</table>;
}
