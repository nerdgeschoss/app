import React, { ReactNode } from 'react';
import './box.scss';

interface Props {
  children: ReactNode;
  size?: number;
  sizeHorizontal?: number;
  sizeTablet?: number;
  sizeTableHorizontal?: number;
  sizeDesktop?: number;
  sizeDesktopHorizontal?: number;
}

export function Box({ children, size, sizeHorizontal }: Props): JSX.Element {
  size = size ?? 8;
  sizeHorizontal = sizeHorizontal ?? size;
  return (
    <div
      className="box"
      style={
        {
          '--size': `${size}px`,
          '--sizeHorizontal': `${sizeHorizontal}px`,
        } as React.CSSProperties
      }
    >
      {children}
    </div>
  );
}
