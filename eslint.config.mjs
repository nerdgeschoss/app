import globals from 'globals';
import { fixupConfigRules } from '@eslint/compat';
import pluginJs from '@eslint/js';
import tseslint from 'typescript-eslint';
import react from 'eslint-plugin-react';

export default [
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  ...tseslint.configs.recommended,
  {
    plugins: react,
  },
  {
    rules: {
      'no-console': 2,
      eqeqeq: 2,
    },
  },
  {
    ignores: ['generated/*'],
  },
];
