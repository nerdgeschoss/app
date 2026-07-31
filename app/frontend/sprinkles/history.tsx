import { JSX, ReactNode } from 'react';
import { Turbo } from '@hotwired/turbo-rails';
import { Meta } from './meta';
import { MetaCache } from './meta_cache';

export function usePath(): string {
  // the React tree remounts on every Turbo visit, so the location at render
  // time is always current
  return window.location.pathname + window.location.search;
}

export function Link({
  id,
  href,
  children,
  className,
}: {
  id?: string;
  href: string;
  children: ReactNode;
  className?: string;
}): JSX.Element {
  return (
    <a id={id} href={href} className={className}>
      {children}
    </a>
  );
}

export class History {
  cache = new MetaCache();

  get path(): string {
    return window.location.pathname + window.location.search;
  }

  async navigate(url: string): Promise<void> {
    Turbo.visit(url);
  }

  async refreshPageContent(): Promise<void> {
    await this.cache.refresh(this.path);
  }

  async extendPageContent(
    path: string,
    merge: (state: Meta, page: Meta) => Meta
  ): Promise<void> {
    await this.cache.extendPageContent(this.path, path, merge);
  }

  async extendPageContentWithPagination(
    path: string,
    propPath: string
  ): Promise<void> {
    await this.extendPageContent(path, (state, page) => ({
      ...state,
      props: {
        ...state.props,
        [propPath]: [
          ...(state.props[propPath] as unknown[]),
          ...(page.props[propPath] as unknown[]),
        ],
        nextPageUrl: (page.props as { nextPageUrl: string }).nextPageUrl,
      },
    }));
  }
}
