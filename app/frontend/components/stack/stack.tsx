import './stack.scss';

import React from 'react';
import classnames from 'classnames';

type Justify = 'left' | 'center' | 'right' | 'space-between' | 'space-around';

type Align = 'top' | 'bottom' | 'center';

type Viewport = 'none' | 'mobile' | 'tablet' | 'desktop';

interface Props {
  size?: number;
  desktopSize?: number;
  tabletSize?: number;
  children: React.ReactNode;
  line?: Viewport;
  justify?: Justify;
  justifyTablet?: Justify;
  justifyDesktop?: Justify;
  align?: Align;
  alignTablet?: Align;
  alignDesktop?: Align;
  grid?: Viewport;
  reverse?: Viewport;
  wrap?: boolean;
  className?: string;
  fullWidth?: Viewport | 'all';
  noShrink?: boolean;
  id?: string;
  onClick?: () => void;
}

export function Stack({
  id,
  children,
  size = 16,
  desktopSize,
  tabletSize,
  line,
  justify,
  justifyTablet,
  justifyDesktop,
  align,
  alignTablet,
  alignDesktop,
  wrap,
  grid,
  className,
  reverse,
  fullWidth = 'all',
  noShrink,
  onClick,
}: Props): JSX.Element {
  return (
    <div
      id={id}
      className={classnames(
        'stack',
        justify && `stack--justify-${justify}`,
        justifyTablet && `stack--tablet-justify-${justifyTablet}`,
        justifyDesktop && `stack--desktop-justify-${justifyDesktop}`,
        align && `stack--align-${align}`,
        alignTablet && `stack--tablet-align-${alignTablet}`,
        alignDesktop && `stack--desktop-align-${alignDesktop}`,
        grid && `stack--grid-${grid}`,
        fullWidth && `stack--full-width-${fullWidth}`,
        {
          'stack--no-shrink': noShrink,
          'stack--line': line === 'mobile',
          'stack--tablet-line': line === 'tablet',
          'stack--desktop-line': line === 'desktop',
          'stack--reverse': reverse === 'mobile',
          'stack--tablet-reverse': reverse === 'tablet',
          'stack--desktop-reverse': reverse === 'desktop',
          'stack--wrap': wrap,
          'stack--clickable': onClick,
        },
        className
      )}
      onClick={onClick}
      style={
        {
          '--size': `${size}px`,
          '--tablet-size': `${tabletSize ?? size}px`,
          '--desktop-size': `${desktopSize ?? tabletSize ?? size}px`,
          '--size-print': `${size}rem`,
        } as React.CSSProperties
      }
    >
      {children}
    </div>
  );
}
