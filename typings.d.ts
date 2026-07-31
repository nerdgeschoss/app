/// <reference types="vite/client" />
declare module '@hotwired/turbo-rails' {
  export const Turbo: {
    visit(
      location: string,
      options?: { action?: 'advance' | 'replace' | 'restore'; frame?: string }
    ): void;
  };
}
