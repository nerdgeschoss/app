import React, { createContext, FunctionComponent, ReactElement } from 'react';
import { createRoot } from 'react-dom/client';
import { Frame } from './frame';
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
  }>;
  history = new History((meta) => this.renderPage(meta.path));

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
      if (/\.[0-9a-z]+$/i.test(target.href)) return; // return early for file links like pdfs
      event.preventDefault();
      this.history.navigate(target.getAttribute('href')!);
    });
  }

  async componentFor(path: string): Promise<FunctionComponent<any> | null> {
    const importPath = '../../views/' + path + '.tsx';
    const implementation = imports[importPath];
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
    let body: FormData | null = null;
    const csrfToken = document
      .querySelector("[name='csrf-token']")
      ?.getAttribute('content');
    if (method !== 'GET' && params) {
      const formData = new FormData();
      serialize(params, formData);
      body = formData;
    }
    const response = await fetch(path, {
      credentials: 'same-origin',
      method,
      body,
      headers: {
        'X-CSRF-Token': csrfToken ?? '',
        'X-Reaction': 'true',
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
    const data = metaJson ? JSON.parse(decodeURIComponent(metaJson)) : {};
    const meta = new Meta(data);
    meta.path = window.location.pathname + window.location.search;
    this.history.cache.write(meta);
    this.root = createRoot(rootElement);
    this.renderPage(meta.path);
  }

  private async renderPage(path: string): Promise<void> {
    const content = React.createElement(Frame, { url: path });
    const app = React.createElement(this.layout || React.Fragment, {
      children: content,
    });
    this.root.render(
      React.createElement(ReactionContext.Provider, { value: this }, app)
    );
  }
}

function serialize(
  obj: object,
  formData: FormData,
  parentPath?: string[]
): void {
  Object.entries(obj).forEach(([key, value]) => {
    const pathElements = [...(parentPath || []), key];
    let path = pathElements.shift()!;
    path += pathElements.map((e) => `[${e}]`).join('');
    if (value === null || value === undefined) {
      formData.append(path, '');
      return;
    }
    if (Array.isArray(value)) {
      value.forEach((v, i) => {
        serialize({ [i]: v }, formData, [...(parentPath || []), key]);
      });
      return;
    }
    if (value instanceof File) {
      formData.append(path, value);
      return;
    }
    if (value instanceof Date) {
      formData.append(path, value.toISOString());
      return;
    }
    if (typeof value === 'object') {
      serialize(value, formData, [...(parentPath || []), key]);
      return;
    }
    formData.append(path, value);
  });
}
