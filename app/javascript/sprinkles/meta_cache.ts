import { Meta } from './meta';

interface CacheResult {
  meta: Meta;
  fresh: boolean;
}

export class MetaCache {
  private cache = new Map<string, Meta>();

  async fetch(url: string): Promise<CacheResult> {
    console.log('fetch', url, this.cache.has(url));
    if (this.cache.has(url)) {
      return { meta: this.cache.get(url)!, fresh: false };
    }
    return { meta: await this.refresh(url), fresh: true };
  }

  async refresh(url: string): Promise<Meta> {
    console.log('refreshing', url);
    const response = await fetch(url, {
      headers: { accept: 'application/json' },
    });
    const body = await response.json();
    const meta = new Meta(body);
    this.cache.set(url, meta);
    return body;
  }

  write(url: string, data: Meta): void {
    this.cache.set(url, data);
  }

  clear(): void {
    this.cache.clear();
  }
}
