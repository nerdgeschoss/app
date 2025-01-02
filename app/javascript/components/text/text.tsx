import classNames from 'classnames';
import React, { ReactNode } from 'react';

import './text.scss';
import { TextType, Color } from './types';

interface Props {
  children: ReactNode;
  type?: TextType;
  color?: Color;
}

export function Text({
  children,
  type = 'tooltip',
  color,
}: Props): JSX.Element {
  const textColorVariable = color ? `var(--${color})` : 'inherit';
  return (
    <div
      className={classNames('text', `text--${type}`)}
      style={{ color: textColorVariable }}
    >
      {children}
    </div>
  );
}
