import React, { ReactNode } from 'react';
import { Link } from '../../sprinkles/history';
import './card.scss';

interface Props {
  children?: ReactNode;
  icon?: ReactNode;
  title?: ReactNode;
  subtitle?: ReactNode;
  context?: ReactNode;
  href?: string;
}

export function Card({
  children,
  icon,
  title,
  subtitle,
  context,
  href,
}: Props): JSX.Element {
  const header = (
    <div className="card__header">
      <div className="card__icon">{icon}</div>
      <div className="card__header-content">
        <div className="card__title">{title}</div>
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
      <Link className="card" href={href}>
        {content}
      </Link>
    );
  }
  return <div className="card">{content}</div>;
}
