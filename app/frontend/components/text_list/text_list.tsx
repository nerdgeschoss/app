import React, { ReactNode } from 'react';

import './text_list.scss';

interface Props {
  children: ReactNode;
}

interface ItemProps {
  children: ReactNode;
}

export function TextList({ children }: Props): JSX.Element {
  return <ul className="text-list">{children}</ul>;
}

export function TextListItem({ children }: ItemProps): JSX.Element {
  return <li>{children}</li>;
}
