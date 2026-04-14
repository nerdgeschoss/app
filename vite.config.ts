import { defineConfig } from 'vite';
import Rails from 'vite-plugin-rails';

export default defineConfig({
  plugins: [Rails()],
  resolve: {
    alias: {
      '@components': new URL('./app/components', import.meta.url).pathname,
    },
  },
  build: {
    assetsInlineLimit: 0,
  },
});
