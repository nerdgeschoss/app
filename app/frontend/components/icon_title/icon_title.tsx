import { Text } from '../text/text';
import './icon_title.scss';
import { type ReactElement } from 'react';

interface Props {
  icon: string;
  title: string;
  color: string;
}

export function IconTitle({ icon, title, color }: Props): ReactElement {
  return (
    <div
      className="icon-title"
      style={
        {
          '--background-color': color,
        } as React.CSSProperties
      }
    >
      <span className="icon-title__icon">{icon}</span>
      <span className="icon-title__text">
        <Text type="card-heading-regular">{title}</Text>
      </span>
    </div>
  );
}
