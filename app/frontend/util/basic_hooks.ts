import { useCallback, useState } from 'react';

export function useRefresh(): () => void {
  const [, setUpdate] = useState(0);
  return useCallback(() => setUpdate((u) => u + 1), [setUpdate]);
}
