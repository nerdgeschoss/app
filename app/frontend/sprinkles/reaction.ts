import React, { createContext, FunctionComponent } from 'react';
import { Turbo } from '@hotwired/turbo-rails';
import { History } from './history';
import { Meta } from './meta';

const imports = import.meta.glob('../../views/**/*.tsx', {});

export const ReactionContext = createContext<Reaction | null>(null);
export const useReaction = (): Reaction => {
  const reaction = React.useContext(ReactionContext);
  if (!reaction) throw new Error('ReactionContext not found');
  return reaction;
};

export class Reaction {
  history = new History();

  async componentFor(path: string): Promise<FunctionComponent<unknown> | null> {
    const importPath = '../../views/' + path + '.tsx';
    const implementation = imports[importPath];
    if (!implementation) return null;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return ((await implementation()) as any).default;
  }

  async call({
    path,
    method,
    params,
    refresh = false,
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
    if (response.headers.get('Content-Type')?.includes('application/json')) {
      const data = await response.json();
      if (data.component) {
        // response.url is the final URL after redirects (the server-provided
        // path loses its query string)
        const landedUrl = new URL(response.url);
        const landed = landedUrl.pathname + landedUrl.search;
        const meta = new Meta(data);
        meta.path = landed;
        this.history.cache.write(meta);
        if (landed !== this.history.path) {
          Turbo.visit(landed);
        }
      }
    }
    if (refresh) {
      await this.history.refreshPageContent();
    }
  }
}

export const reaction = new Reaction();

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
        if (typeof v === 'object' && !(v instanceof Date)) {
          serialize({ [i]: v }, formData, [...(parentPath || []), key]);
        } else if (v instanceof Date) {
          formData.append(path + `[]`, v.toISOString());
        } else {
          formData.append(path + `[]`, v);
        }
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
