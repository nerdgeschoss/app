import { Icon } from '../icon/icon';
import { Text } from '../text/text';
import './tooltip.scss';
import { type ReactElement } from 'react';

interface Props {
  content?: ReactElement | string;
  children?: ReactElement;
}

export function Tooltip({ content, children }: Props): ReactElement {
  return (
    <div className="tooltip">
      <div className="tooltip__main">{children}</div>
      <div className="tooltip__anchor">
        <Icon name="tooltip-arrow" size={10} />
        <div className="tooltip__content">
          <Text type="tooltip-primary" color="tooltip-label-default">
            {content}
          </Text>
        </div>
      </div>
    </div>
  );
}
