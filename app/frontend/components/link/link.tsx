import { Text } from '../text/text';
import './link.scss';
import { type ReactElement } from 'react';
import { Link as SprinklesLink } from '../../sprinkles/history';
import classnames from 'classnames';

interface Props {
  href: string;
  disabled?: boolean;
  children: React.ReactNode;
}

export function Link({ href, children, disabled }: Props): ReactElement {
  return (
    <span className={classnames('link', { 'link--disabled': disabled })}>
      <SprinklesLink href={href}>
        <Text type="button-bold">{children}</Text>
      </SprinklesLink>
    </span>
  );
}
