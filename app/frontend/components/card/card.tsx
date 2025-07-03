import React, { ReactNode } from 'react';
import { Link } from '../../sprinkles/history';
import './card.scss';
import { Text } from '../text/text';
import classnames from 'classnames';

interface Props {
  id?: string;
  children?: ReactNode;
  icon?: ReactNode;
  title?: ReactNode;
  subtitle?: ReactNode;
  context?: ReactNode;
  href?: string;
  type?: 'login-card';
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
}: Props): JSX.Element {
  const cardClass = classnames('card', {
    'card--login': type === 'login-card',
  });

  const header = (
    <div className="card__header">
      {icon && <div className="card__icon">{icon}</div>}
      <div className="card__header-content">
        <div className="card__title">
          <Text>{title}</Text>
        </div>
        {subtitle && <div className="card__subtitle">{subtitle}</div>}
      </div>
      {context && <div className="card__context">{context}</div>}
    </div>
  );

  const content = (
    <>
      {header}
      {children && <div className="card__content">{children}</div>}
    </>
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
