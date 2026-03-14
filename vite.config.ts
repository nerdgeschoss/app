import { defineConfig } from 'vite';
import Rails from 'vite-plugin-rails';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [Rails(), react()],
  resolve: {
    alias: {
      '@components': new URL('./app/components', import.meta.url).pathname,
    },
  },
  build: {
    assetsInlineLimit: 0,
  },
});
