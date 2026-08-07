import { Controller } from '@hotwired/stimulus';
import { createRoot, Root } from 'react-dom/client';
import { reaction, ReactionContext } from '../sprinkles/reaction';
import { Frame } from '../sprinkles/frame';
import { Layout } from '../layout';
import { Meta } from '../sprinkles/meta';

export default class ReactionController extends Controller<HTMLElement> {
  static targets = ['data', 'root'];
  declare readonly dataTarget: HTMLTemplateElement;
  declare readonly rootTarget: HTMLElement;
  private root: Root | null = null;

  connect(): void {
    // Turbo preview snapshots already contain the last-rendered HTML; the
    // controller connects again once the fresh body arrives.
    if (document.documentElement.hasAttribute('data-turbo-preview')) return;
    const raw = this.dataTarget.content.textContent;
    const meta = new Meta(raw ? JSON.parse(decodeURIComponent(raw)) : {});
    // the server strips the query string from the path; key the cache by the real URL
    const url = window.location.pathname + window.location.search;
    meta.path = url;
    reaction.history.cache.clear();
    reaction.history.cache.write(meta);
    document.body.classList.remove('with-modal');
    this.root = createRoot(this.rootTarget);
    this.root.render(
      <ReactionContext.Provider value={reaction}>
        <Layout>
          <Frame url={url} />
        </Layout>
      </ReactionContext.Provider>
    );
  }

  disconnect(): void {
    this.root?.unmount();
    this.root = null;
  }
}
