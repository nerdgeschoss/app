import { Meta } from './meta';
import { MetaCache } from './meta_cache';

export class History {
  cache = new MetaCache();
  private path: string = window.location.pathname + window.location.search;

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

  async restore(): Promise<void> {
    const url = window.location.pathname + window.location.search;
    const result = await this.cache.fetch(url);
    this.path = url;
    this.onChange(result.meta);
  }
}
