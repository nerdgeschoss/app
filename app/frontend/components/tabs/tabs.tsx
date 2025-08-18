import './tabs.scss';
import { type ReactElement } from 'react';
import classnames from 'classnames';
import { Text } from '../text/text';

interface Props {
  items: Array<{ label: string; href: string; active?: boolean }>;
}

export function Tabs({ items }: Props): ReactElement {
  return (
    <div className="tabs">
      {items.map((item) => (
        <a
          key={item.href}
          href={item.href}
          className={classnames('tabs__item', {
            'tabs__item--active': item.active,
          })}
        >
          <Text type={item.active ? 'button-bold' : 'button-regular'}>
            {item.label}
          </Text>
        </a>
      ))}
    </div>
  );
}
