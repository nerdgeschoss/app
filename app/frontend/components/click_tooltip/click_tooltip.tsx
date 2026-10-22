import './click_tooltip.scss';

import {
  JSX,
  ReactNode,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
} from 'react';

interface Props {
  trigger: ReactNode;
  children: ReactNode;
}

export function ClickTooltip({ trigger, children }: Props): JSX.Element {
  const rootRef = useRef<HTMLSpanElement>(null);
  const cardRef = useRef<HTMLDivElement>(null);
  const [open, setOpen] = useState(false);

  // the card hangs left from the trigger's right edge, so on a phone a wrapped
  // card can reach past the left edge; shift it back inside the 16px gutter
  useLayoutEffect(() => {
    const card = cardRef.current;
    if (!card) return;
    const place = (): void => {
      card.style.right = '';
      const overflow = 16 - card.getBoundingClientRect().left;
      if (overflow > 0) {
        card.style.right = `${-overflow}px`;
      }
    };
    place();
    window.addEventListener('resize', place);
    return () => window.removeEventListener('resize', place);
  }, [open]);

  // click only: any click outside closes the tooltip, including the trigger of
  // another tooltip on the page, so clicks are not stopped from bubbling
  useEffect(() => {
    if (!open) return;
    const close = (event: MouseEvent): void => {
      if (!rootRef.current?.contains(event.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('click', close);
    return () => document.removeEventListener('click', close);
  }, [open]);

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
      {open && (
        <div className="click-tooltip__card" ref={cardRef}>
          {children}
        </div>
      )}
    </span>
  );
}
