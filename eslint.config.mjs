import globals from 'globals';
import pluginJs from '@eslint/js';
import tseslint from 'typescript-eslint';
import react from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';

export default [
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      'no-console': 2,
      eqeqeq: 2,
    },
    plugins: {'react-hooks': reactHooks, 'react': react},
  },
  {
    ignores: ['generated/*'],
  },
];
