import classNames from 'classnames';
import React, { ReactNode } from 'react';

import './text.scss';
import { TextType, Color } from './types';

interface Props {
  children: ReactNode;
  type?: TextType;
  color?: Color;
  multiline?: boolean;
  block?: boolean;
  uppercase?: boolean;
  noWrap?: boolean;
}

export function Text({
  children,
  type = 'body-regular',
  color,
  multiline,
  block,
  uppercase,
  noWrap,
}: Props): JSX.Element {
  const textColorVariable = color ? `var(--${color})` : 'inherit';
  if (typeof children === 'string' && multiline) {
    children = children.split('\n').map((e, i) => <p key={i}>{e}</p>);
  }
  return (
    <div
      className={classNames('text', `text--${type}`, {
        'text--multiline': multiline,
        'text--block': block,
        'text--uppercase': uppercase,
        'text--no-wrap': noWrap,
      })}
      style={{ color: textColorVariable }}
    >
      {children}
    </div>
  );
}
