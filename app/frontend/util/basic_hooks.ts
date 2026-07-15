import { useCallback, useState } from 'react';

export function useRefresh(): () => void {
  const [, setUpdate] = useState(0);
  return useCallback(() => setUpdate((u) => u + 1), [setUpdate]);
}

export function wrapArray<T>(element: T | T[]): T[] {
  if (Array.isArray(element)) {
    return [...element];
  } else {
    return [element];
  }
}
