import './section_card.scss';
import React, { type ReactElement } from 'react';

interface Props {
  header: ReactElement;
  children: ReactElement | ReactElement[];
}

export function SectionCard({ header, children }: Props): ReactElement {
  return (
    <div className="section_card">
      <header className="section_card__header">{header}</header>
      {Array.isArray(children) ? (
        children.map((child, index) => (
          <main key={index} className="section_card__section">
            {child}
          </main>
        ))
      ) : (
        <main className="section_card__section">{children}</main>
      )}
    </div>
  );
}
