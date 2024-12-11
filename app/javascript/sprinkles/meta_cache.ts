import { Meta } from './meta';

interface CacheResult {
  meta: Meta;
  fresh: boolean;
}

export class MetaCache {
  private cache = new Map<string, Meta>();
  private subscriptions = new Map<string, MetaCacheSubscription[]>();

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
    this.write(url, meta);
    return body;
  }

  write(url: string, data: Meta): void {
    this.cache.set(url, data);
    this.updateSubscriptions(url);
  }

  clear(): void {
    this.cache.clear();
    this.subscriptions.clear();
  }

  subscribe(url: string, callback: (meta: any) => void): MetaCacheSubscription {
    const subscription = new MetaCacheSubscription(this, url, callback);
    const existing = this.subscriptions.get(url) || [];
    this.subscriptions.set(url, [...existing, subscription]);
    return subscription;
  }

  unsubscribe(url: string, subscription: MetaCacheSubscription): void {
    const existing = this.subscriptions.get(url) || [];
    this.subscriptions.set(
      url,
      existing.filter((s) => s !== subscription)
    );
  }

  private updateSubscriptions(url: string): void {
    const data = this.cache.get(url);
    const subscriptions = this.subscriptions.get(url) || [];
    subscriptions.forEach((s) => s.call(data));
  }
}

export class MetaCacheSubscription {
  constructor(
    private cache: MetaCache,
    private url: string,
    private callback: (data: any) => void
  ) {}

  call(data: any): void {
    this.callback(data);
  }

  unsubscribe(): void {
    this.cache.unsubscribe(this.url, this);
  }
}
