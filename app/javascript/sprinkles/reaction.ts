import React, { createContext, FunctionComponent, ReactElement } from 'react';
import { createRoot } from 'react-dom/client';
import { History } from './history';
import { Meta } from './meta';

const imports = import.meta.glob('../../views/**/*.tsx', {});

const ReactionContext = createContext<Reaction | null>(null);
export const useReaction = (): Reaction => {
  const reaction = React.useContext(ReactionContext);
  if (!reaction) throw new Error('ReactionContext not found');
  return reaction;
};

export class Reaction {
  private root!: ReturnType<typeof createRoot>;
  private layout?: FunctionComponent<{
    children: ReactElement;
    reaction: Reaction;
  }>;
  history = new History((meta) => this.renderPage(meta));

  constructor({ layout }: { layout?: Reaction['layout'] } | undefined = {}) {
    this.layout = layout;
  }

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
      if (target.target === '_blank') return;
      if (!target.href.startsWith(document.location.origin)) return;
      event.preventDefault();
      this.history.navigate(target.getAttribute('href')!);
    });
  }

  async componentFor(path: string): Promise<FunctionComponent<any> | null> {
    const importPath = '../../views/' + path + '.tsx';
    const implementation = imports[importPath];
    console.log('implementation', path, importPath, implementation);
    if (!implementation) return null;
    return ((await implementation()) as any).default;
  }

  async call({
    path,
    method,
    params,
    refresh = true,
  }: {
    path: string;
    method: 'GET' | 'POST' | 'PATCH' | 'DELETE';
    params?: object;
    refresh?: boolean;
  }): Promise<void> {
    let body = '';
    const csrfToken = document
      .querySelector("[name='csrf-token']")
      ?.getAttribute('content');
    if (method !== 'GET' && params) {
      body = JSON.stringify(params);
    }
    const response = await fetch(path, {
      credentials: 'same-origin',
      method,
      body,
      headers: {
        'X-CSRF-Token': csrfToken ?? '',
        'X-Reaction': 'true',
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
    });
    if (!response.ok) {
      throw new Error(response.statusText);
    }
    if (refresh) {
      await this.history.refreshPageContent();
    }
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
    const App = await this.componentFor(meta.component);
    if (!App) return;
    const content = React.createElement(App, { data: meta.props });
    const app = React.createElement(this.layout || React.Fragment, {
      children: content,
      reaction: this,
    });
    this.root.render(
      React.createElement(ReactionContext.Provider, { value: this }, app)
    );
  }
}
