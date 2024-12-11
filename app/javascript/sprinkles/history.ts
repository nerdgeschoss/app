import { Meta } from './meta';
import { MetaCache } from './meta_cache';

export class History {
  cache = new MetaCache();

  constructor(private onChange: (meta: Meta) => void) {
    window.addEventListener('popstate', this.restore.bind(this));
  }

  async navigate(url: string): Promise<void> {
    const result = await this.cache.fetch(url);
    window.history.pushState({}, '', url);
    this.onChange(result.meta);
    if (result.fresh) return;
    this.onChange(await this.cache.refresh(url));
  }

  async refreshPageContent(): Promise<void> {
    const url = window.location.pathname + window.location.search;
    this.onChange(await this.cache.refresh(url));
  }

  async restore(): Promise<void> {
    const url = window.location.pathname + window.location.search;
    const result = await this.cache.fetch(url);
    this.onChange(result.meta);
  }
}
