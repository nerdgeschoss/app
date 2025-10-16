import './grid.scss';

import React from 'react';
import classnames from 'classnames';

interface Props {
  children: React.ReactNode;
}

export function Grid({ children }: Props): JSX.Element {
  return <div className={classnames('grid')}>{children}</div>;
}
