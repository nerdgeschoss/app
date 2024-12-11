import React from 'react';
import { loadI18n } from './i18n';
import type { Formatter } from './formatter';

const DependenciesContext = React.createContext<Dependencies | null>(null);

interface Dependencies {
  i18n: ReturnType<typeof loadI18n>;
  formatter: Formatter;
}

function useDependencies(): Dependencies {
  const dependencies = React.useContext(DependenciesContext);
  if (!dependencies) {
    throw new Error(
      'useDependencies must be used within a DependenciesProvider'
    );
  }
  return dependencies;
}

interface Props extends Dependencies {
  children: React.ReactElement;
}

export function DependenciesProvider({
  children,
  ...dependencies
}: Props): JSX.Element {
  return (
    <DependenciesContext.Provider value={dependencies}>
      {children}
    </DependenciesContext.Provider>
  );
}

export function useFormatter(): Dependencies['formatter'] {
  return useDependencies().formatter;
}

export function useI18n(): Dependencies['i18n'] {
  return useDependencies().i18n;
}

export function useTranslate(): Dependencies['i18n']['t'] {
  const i18n = useI18n();
  return i18n.t.bind(i18n);
}
