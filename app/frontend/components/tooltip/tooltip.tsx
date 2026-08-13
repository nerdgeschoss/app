import { Icon } from '../icon/icon';
import { Text } from '../text/text';
import { type ReactElement, useRef, useState } from 'react';
import { createPortal } from 'react-dom';

interface Props {
  content?: ReactElement | string;
  children?: ReactElement;
}

interface Position {
  top: number;
  left: number;
}

export function Tooltip({ content, children }: Props): ReactElement {
  const triggerRef = useRef<HTMLDivElement>(null);
  const [position, setPosition] = useState<Position | null>(null);

  const show = (): void => {
    const rect = triggerRef.current?.getBoundingClientRect();
    if (rect)
      setPosition({ top: rect.top + rect.height / 2, left: rect.right });
  };
  const hide = (): void => setPosition(null);

  return (
    <div
      className="tooltip"
      ref={triggerRef}
      onMouseEnter={show}
      onMouseLeave={hide}
    >
      <div className="tooltip__main">{children}</div>
      {content &&
        position &&
        createPortal(
          <div
            className="tooltip__anchor tooltip__anchor--visible"
            style={{ top: position.top, left: position.left }}
          >
            <Icon name="tooltip-arrow" size={10} />
            <div className="tooltip__content">
              <Text type="tooltip-primary" color="tooltip-label-default" noWrap>
                {content}
              </Text>
            </div>
          </div>,
          document.body
        )}
    </div>
  );
}
