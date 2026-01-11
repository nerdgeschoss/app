import './grid.scss';

import React from 'react';
import classnames from 'classnames';

interface Props {
  children: React.ReactNode;
  minColumnWidth?: number;
  gap?: number;
  horizontalGap?: number;
}

export function Grid({
  children,
  minColumnWidth,
  gap,
  horizontalGap,
}: Props): JSX.Element {
  return (
    <div
      className={classnames('grid')}
      style={
        {
          '--min-width': `${minColumnWidth ?? 300}px`,
          '--gap': `${gap ?? 24}px`,
          '--horizontal-gap': `${horizontalGap ?? gap ?? 24}px`,
        } as React.CSSProperties
      }
    >
      {children}
    </div>
  );
}
