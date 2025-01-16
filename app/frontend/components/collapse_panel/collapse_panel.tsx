import React, { useEffect } from 'react';
import classnames from 'classnames';
import './collapse_panel.scss';

type RenderFunction = () => React.ReactNode;

export interface Props {
  open?: boolean;
  children: React.ReactNode | RenderFunction;
}

export function CollapsePanel({ open, children }: Props): JSX.Element {
  const ref = React.useRef<HTMLDivElement>(null);

  function toggleOverflow(): void {
    const container = ref.current;
    if (container !== null) {
      if (container.classList.contains('collapse-panel--open')) {
        container.setAttribute('style', '--collapse-panel-overflow: visible');
      } else {
        container.setAttribute('style', '--collapse-panel-overflow: hidden');
      }
    }
  }

  useEffect(() => {
    toggleOverflow();
  }, []);

  return (
    <div
      ref={ref}
      className={classnames('collapse-panel', { 'collapse-panel--open': open })}
      onTransitionEnd={toggleOverflow}
    >
      <div className="collapse-panel__content">
        {typeof children === 'function' ? children() : children}
      </div>
    </div>
  );
}
