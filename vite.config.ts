import { defineConfig } from 'vite';
import Rails from 'vite-plugin-rails';
import sassGlobImports from 'vite-plugin-sass-glob-import';

export default defineConfig({
  plugins: [Rails(), sassGlobImports()],
});
