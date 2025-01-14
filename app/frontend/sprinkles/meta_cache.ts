import { Meta } from './meta';

interface CacheResult {
  meta: Meta;
  fresh: boolean;
}

export class MetaCache {
  private cache = new Map<string, Meta>();
  private subscriptions = new Map<string, MetaCacheSubscription[]>();

  async fetch(url: string): Promise<CacheResult> {
    if (this.cache.has(url)) {
      return { meta: this.cache.get(url)!, fresh: false };
    }
    return { meta: await this.refresh(url), fresh: true };
  }

  async refresh(url: string): Promise<Meta> {
    const body = await this.loadMeta(url);
    this.write(body);
    return body;
  }

  write(data: Meta): void {
    this.cache.set(data.path, data);
    this.updateSubscriptions(data.path);
  }

  clear(): void {
    this.cache.clear();
    this.subscriptions.clear();
  }

  subscribe(
    url: string,
    callback: (meta: unknown) => void
  ): MetaCacheSubscription {
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

  async extendPageContent(
    currentPath: string,
    nextPath: string,
    merge: (state: Meta, page: Meta) => Meta
  ): Promise<void> {
    const currentState = this.cache.get(currentPath);
    if (!currentState)
      throw new Error('Current state not found for path: ' + currentPath);
    const nextState = await this.loadMeta(nextPath);
    this.write(merge(currentState!, nextState));
  }

  private updateSubscriptions(url: string): void {
    const data = this.cache.get(url);
    const subscriptions = this.subscriptions.get(url) || [];
    subscriptions.forEach((s) => s.call(data?.props));
  }

  private async loadMeta(url: string): Promise<Meta> {
    const response = await fetch(url, {
      headers: { accept: 'application/json' },
    });
    const body = await response.json();
    const meta = new Meta(body);
    meta.path = url;
    return meta;
  }
}

export class MetaCacheSubscription {
  constructor(
    private cache: MetaCache,
    private url: string,
    private callback: (data: unknown) => void
  ) {}

  call(data: unknown): void {
    this.callback(data);
  }

  unsubscribe(): void {
    this.cache.unsubscribe(this.url, this);
  }
}
