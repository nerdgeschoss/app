import React, { ReactNode } from 'react';

interface Props {
  children?: ReactNode;
  icon?: ReactNode;
  title?: ReactNode;
  subtitle?: ReactNode;
  context?: ReactNode;
}

export function Card({
  children,
  icon,
  title,
  subtitle,
  context,
}: Props): JSX.Element {
  return (
    <div className="card">
      <div className="card__header">
        <div className="card__icon">{icon}</div>
        <div className="card__header-content">
          <div className="card__title">{title}</div>
          {subtitle && <div className="card__subtitle">{subtitle}</div>}
          {children}
        </div>
        {context && <div className="card__context">{context}</div>}
      </div>
    </div>
  );
}
