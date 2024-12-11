import { useRef, useEffect } from 'react';

export function useOnMount(callback: () => void): void {
  const didRender = useRef(false);
  useEffect(() => {
    // this will run twice in dev mode hence the ref
    if (!didRender.current) {
      callback();
    }
    didRender.current = true;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
}
