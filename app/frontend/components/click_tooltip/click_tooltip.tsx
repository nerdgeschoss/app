import './click_tooltip.scss';

import { JSX, ReactNode, useEffect, useRef, useState } from 'react';

interface Props {
  trigger: ReactNode;
  children: ReactNode;
}

export function ClickTooltip({ trigger, children }: Props): JSX.Element {
  const rootRef = useRef<HTMLSpanElement>(null);
  const [open, setOpen] = useState(false);

  // click only: any click outside closes the tooltip, including the trigger of
  // another tooltip on the page, so clicks are not stopped from bubbling
  useEffect(() => {
    const close = (event: MouseEvent): void => {
      if (!rootRef.current?.contains(event.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('click', close);
    return () => document.removeEventListener('click', close);
  }, []);

  return (
    <span className="click-tooltip" ref={rootRef}>
      <button
        type="button"
        className="click-tooltip__trigger"
        aria-expanded={open}
        onClick={() => setOpen((open) => !open)}
      >
        {trigger}
      </button>
      {open && <div className="click-tooltip__card">{children}</div>}
    </span>
  );
}
