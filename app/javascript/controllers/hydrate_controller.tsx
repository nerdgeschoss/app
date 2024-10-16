import { Controller } from '@hotwired/stimulus';
import React from 'react';
import { createRoot } from 'react-dom/client';

const imports = import.meta.glob('../../views/pages/**/*.tsx', {});

// Connects to data-controller="autosubmitting"
export default class extends Controller {
  private root!: ReturnType<typeof createRoot>;

  async connect(): Promise<void> {
    if (!this.root) {
      this.root = createRoot(this.element);
    }
    const implementation = imports['../../views/' + this.componentName];
    if (!implementation) return;
    const App = ((await implementation()) as any).default;
    this.root.render(<App {...this.props} />);
  }

  disconnect(): void {
    this.root.unmount();
  }

  private get componentName(): string {
    const el = this.element as HTMLElement;
    return el.dataset['component'] ?? '';
  }

  private get props(): Record<string, unknown> {
    const el = this.element as HTMLElement;
    return JSON.parse(el.dataset['props'] ?? '{}');
  }
}
