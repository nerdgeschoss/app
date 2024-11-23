import React from 'react';
import { createRoot } from 'react-dom/client';
import { History } from './history';
import { Meta } from './meta';

const imports = import.meta.glob('../../views/**/*.tsx', {});

export class Reaction {
  private root!: ReturnType<typeof createRoot>;
  history = new History((meta) => this.renderPage(meta));

  start(): void {
    document.addEventListener('DOMContentLoaded', () => {
      this.loadPage();
    });
    document.addEventListener('click', (event) => {
      let target = event.target as HTMLAnchorElement;
      while (target && target.tagName !== 'A') {
        if (target === document.body) return;
        target = target.parentElement as HTMLAnchorElement;
      }
      if (!target) return;
      event.preventDefault();
      this.history.navigate(target.getAttribute('href')!);
    });
  }

  private async loadPage(): Promise<void> {
    const rootElement = document.getElementById('root');
    if (!rootElement) throw new Error('Root element not found');
    const metaJson = (
      document.querySelector('meta[name="reaction-data"]') as HTMLMetaElement
    ).content;
    const data = metaJson ? JSON.parse(metaJson) : {};
    const meta = new Meta(data);
    this.history.cache.write(window.location.pathname, meta);
    this.root = createRoot(rootElement);
    this.renderPage(meta);
  }

  private async renderPage(meta: Meta): Promise<void> {
    const importPath = '../../views/' + meta.component + '.tsx';
    const implementation = imports[importPath];
    if (!implementation) return;
    const App = ((await implementation()) as any).default;
    this.root.render(React.createElement(App, { data: meta.props }));
  }
}
