import './icon.scss';
import React from 'react';
import classnames from 'classnames';
import { Color } from '../text/types';
import './icon.scss';

export type IconName =
  | 'dashboard'
  | 'leave'
  | 'logout'
  | 'payslip'
  | 'sprint'
  | 'user'
  | 'menu'
  | 'close'
  | 'tooltip-arrow'
  | 'chevron-arrow'
  | 'project'
  | 'github';

interface Props {
  name: IconName;
  size?: number;
  tabletSize?: number;
  desktopSize?: number;
  color?: Color;
}

export function Icon({
  name,
  size = 20,
  tabletSize,
  desktopSize,
  color,
}: Props): JSX.Element {
  return (
    <span
      className={classnames('icon', `icon--${name}`)}
      style={
        {
          '--icon-size': `${size}px`,
          '--icon-tablet-size': `${tabletSize ?? size}px`,
          '--icon-desktop-size': `${desktopSize ?? tabletSize ?? size}px`,
          ...(color ? { '--icon-color': `var(--${color})` } : {}),
        } as React.CSSProperties
      }
    />
  );
}
