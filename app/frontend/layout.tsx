import { ModalWrapper } from './components/modal/modal';
import React, { ReactNode } from 'react';
import { loadI18n } from './util/i18n';
import { Formatter } from './util/formatter';
import { DependenciesProvider } from './util/dependencies';

interface Props {
  children: ReactNode;
}

const locale = document.documentElement.lang === 'en' ? 'en' : 'en';
const i18n = loadI18n(locale);
const formatter = new Formatter({ locale });

export function Layout({ children }: Props): JSX.Element {
  return (
    <DependenciesProvider i18n={i18n} formatter={formatter}>
      <ModalWrapper>{children}</ModalWrapper>
    </DependenciesProvider>
  );
}
