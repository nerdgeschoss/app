import { useEffect } from 'react';
import { useRefresh } from './basic_hooks';

interface DisplayedError {
  message: string;
  error: unknown;
  confirm: () => void;
}

class ErrorManager {
  static _instance: ErrorManager;

  static get instance() {
    if (!this._instance) {
      this._instance = new ErrorManager();
    }
    return this._instance;
  }

  errors: DisplayedError[] = [];
  listeners: (() => void)[] = [];

  handleError(error: unknown) {
    const message = error instanceof Error ? error.message : String(error);
    const displayedError: DisplayedError = {
      message,
      error,
      confirm: () => {},
    };
    displayedError.confirm = () => {
      this.errors = this.errors.filter((e) => e !== displayedError);
      this.listeners.forEach((listener) => listener());
    };
    this.errors.push(displayedError);
    this.listeners.forEach((listener) => listener());
  }

  addListener(listener: () => void) {
    this.listeners.push(listener);
  }

  removeListener(listener: () => void) {
    this.listeners = this.listeners.filter((l) => l !== listener);
  }
}

export function useErrors(): DisplayedError[] {
  const refresh = useRefresh();
  const errors = ErrorManager.instance.errors;
  useEffect(() => {
    ErrorManager.instance.addListener(refresh);
    return () => ErrorManager.instance.removeListener(refresh);
  }, []);
  return errors;
}

export function handleError(error: unknown) {
  ErrorManager.instance.handleError(error);
}

const GENERIC_ERRORS = {
  required: 'errors.required-field',
  'required-field': 'errors.required-field',
  'invalid-email-address': 'errors.invalid-email-address',
  email: 'errors.invalid-email-address',
  'default-error': 'errors.default-error',
  'invalid-code': 'errors.invalid-code',
} as const;

export function getErrorMessage(errorCode: string) {
  return (
    GENERIC_ERRORS[errorCode as keyof typeof GENERIC_ERRORS] ||
    GENERIC_ERRORS['default-error']
  );
}
