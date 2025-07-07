import React, { ReactNode } from 'react';
import { Link } from '../../sprinkles/history';
import './card.scss';
import { Text } from '../text/text';
import classnames from 'classnames';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';

interface Props {
  id?: string;
  children?: ReactNode;
  icon?: ReactNode;
  title?: ReactNode;
  subtitle?: ReactNode;
  context?: ReactNode;
  href?: string;
  type?: 'login-card';
  iconSize?: number;
  withDivider?: boolean;
}

export function Card({
  id,
  children,
  icon,
  title,
  subtitle,
  context,
  href,
  type,
  iconSize = 28,
  withDivider,
}: Props): JSX.Element {
  const cardClass = classnames('card', {
    'card--login': type === 'login-card',
  });
  const style = {
    '--icon-size': `${iconSize}px`,
  } as React.CSSProperties;

  const hasHeader = title || subtitle || context || icon;

  const header = hasHeader && (
    <div className="card__header" style={style}>
      <div className="card__header-content">
        <div className="card__title">
          {icon && <div className="card__icon">{icon}</div>}
          <Text type="h5-bold" color="label-heading-primary" uppercase>
            {title}
          </Text>
        </div>
        {subtitle && <div className="card__subtitle">{subtitle}</div>}
      </div>
      {context && <div className="card__context">{context}</div>}
    </div>
  );

  const content = (
    <Stack gap={24}>
      {header}
      {withDivider && <div className="card__divider" />}
      {children && <div className="card__content">{children}</div>}
    </Stack>
  );

  if (href) {
    return (
      <Link className={cardClass} href={href} id={id}>
        {content}
      </Link>
    );
  }
  return (
    <div className={cardClass} id={id}>
      {content}
    </div>
  );
}
