import classNames from 'classnames';
import React, { ReactNode } from 'react';

import './text.scss';
import { Font } from './types';

interface Props {
  children: ReactNode;
  type?: Font;
}

export function Text({ children, type = 'default' }: Props): JSX.Element {
  return <div className={classNames('text', `text--${type}`)}>{children}</div>;
}
