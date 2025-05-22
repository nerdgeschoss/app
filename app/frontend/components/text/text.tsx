import classNames from 'classnames';
import React, { ReactNode } from 'react';

import './text.scss';
import { TextType, Color } from './types';

interface Props {
  children: ReactNode;
  type?: TextType;
  color?: Color;
  multiline?: boolean;
}

export function Text({
  children,
  type = 'body-regular',
  color,
  multiline,
}: Props): JSX.Element {
  const textColorVariable = color ? `var(--${color})` : 'inherit';
  if (typeof children === 'string' && multiline) {
    children = children.split('\n').map((e, i) => <p key={i}>{e}</p>);
  }
  return (
    <div
      className={classNames('text', `text--${type}`, {
        'text--multiline': multiline,
      })}
      style={{ color: textColorVariable }}
    >
      {children}
    </div>
  );
}
