import { I18n, TranslateOptions } from 'i18n-js';

import React from 'react';
import en from '../locale/en.json';

export type Locale = 'en';

type TranslationKeys<T> = T extends object
  ? {
      [K in keyof T]: `${Exclude<K, symbol>}${TranslationKeys<
        T[K]
      > extends never
        ? ''
        : `.${TranslationKeys<T[K]>}`}`;
    }[keyof T]
  : never;

type NestedTranslationKeys = TranslationKeys<typeof en>;

type Interpolate = (
  i18n: I18n,
  message: string,
  options: TranslateOptions
) => string | JSX.Element;

interface TypedI18n extends Omit<I18n, 'interpolate' | 't'> {
  interpolate: Interpolate;
  t: (scope: NestedTranslationKeys, options?: TranslateOptions) => string;
}

export function loadI18n(locale: Locale): TypedI18n {
  const i18n = new I18n({ en }) as TypedI18n;
  i18n.enableFallback = true;
  i18n.locale = locale;
  i18n.interpolate = (i18n, message, options) => {
    options = Object.keys(options).reduce((buffer, key) => {
      buffer[i18n.transformKey(key)] = options[key];
      return buffer;
    }, {} as TranslateOptions);
    const matches = message.match(i18n.placeholder);

    if (!matches) {
      return message;
    }

    const fragments: Array<string | JSX.Element> = [];

    while (matches.length) {
      let value: string | JSX.Element;
      const placeholder = matches.shift() as string;
      const name = placeholder.replace(i18n.placeholder, '$1');
      const regex = new RegExp(
        placeholder.replace(/\{/gm, '\\{').replace(/\}/gm, '\\}')
      );

      if (options[name] !== undefined && options[name] !== null) {
        if (typeof options[name] === 'string') {
          value = options[name].toString().replace(/\$/gm, '_#$#_');
        } else {
          value = options[name]; // assume it's a React component or JSX element
        }
      } else if (name in options) {
        value = i18n.nullPlaceholder(i18n, placeholder, message, options);
      } else {
        value = i18n.missingPlaceholder(i18n, placeholder, message, options);
      }

      if (typeof value === 'string') {
        message = message.replace(regex, value);
      } else {
        const splitMessage = message.split(regex);

        fragments.push(splitMessage[0], value);
        message = splitMessage[1];
      }
    }

    fragments.push(message);

    return fragments.length > 1
      ? React.createElement(React.Fragment, null, fragments)
      : message.replace(/_#\$#_/g, '$');
  };
  return i18n;
}
