import React, { ReactNode, useEffect, useState } from 'react';
import { Meta } from './meta';
import { MetaCache } from './meta_cache';
import { useReaction } from './reaction';

export function usePath(): string {
  const history = useReaction().history;
  const [path, setPath] = useState(history.path);
  useEffect(() => {
    const listener = (history: History) => {
      setPath(history.path);
    };
    history.subscribe(listener);
    return () => {
      history.unsubscribe(listener);
    };
  }, [history]);
  return path;
}

export function Link({
  href,
  children,
  className,
}: {
  href: string;
  children: ReactNode;
  className?: string;
}): JSX.Element {
  const history = useReaction().history;
  return (
    <a
      href={href}
      onClick={(event) => {
        event.preventDefault();
        history.navigate(href);
      }}
      className={className}
    >
      {children}
    </a>
  );
}

export class History {
  cache = new MetaCache();
  path: string = window.location.pathname + window.location.search;
  listeners: Array<(history: History) => void> = [];

  constructor(private onChange: (meta: Meta) => void) {
    window.addEventListener('popstate', this.restore.bind(this));
  }

  async navigate(url: string): Promise<void> {
    const result = await this.cache.fetch(url);
    window.history.pushState({}, '', url);
    this.path = url;
    this.onChange(result.meta);
    if (result.fresh) return;
    this.onChange(await this.cache.refresh(url));
    this.listeners.forEach((e) => e(this));
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
        [propPath]: [...state.props[propPath], ...page.props[propPath]],
        nextPageUrl: page.props.nextPageUrl,
      },
    }));
  }

  async restore(): Promise<void> {
    const url = window.location.pathname + window.location.search;
    const result = await this.cache.fetch(url);
    this.path = url;
    this.onChange(result.meta);
  }

  subscribe(listener: (history: History) => void): void {
    this.listeners.push(listener);
  }

  unsubscribe(listener: (history: History) => void): void {
    this.listeners = this.listeners.filter((e) => e !== listener);
  }
}
