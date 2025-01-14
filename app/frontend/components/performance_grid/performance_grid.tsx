import React, { ReactNode } from 'react';
import './performance_grid.scss';

interface Props {
  children?: ReactNode;
}

export function PerformanceGrid({ children }: Props): JSX.Element {
  return <div className="performance-grid">{children}</div>;
}
