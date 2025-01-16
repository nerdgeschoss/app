import { useMemo } from 'react';

export interface FormField<T> {
  value: T;
  name?: string;
  ariaLabel?: string;
  required?: boolean;
  errors?: string[];
  inputId?: string;
  disabled?: boolean;
  readOnly?: boolean;
  touched?: boolean;
  valid?: boolean;
  customErrorMessage?: string;
  placeholder?: string;
  onChange?: (value: T) => void;
  onBlur?: () => void;
  onFocus?: () => void;
}

export interface SelectOption<T extends string> {
  value: T;
  label: string;
}

function randomId(length = 10): string {
  return Math.random()
    .toString(36)
    .substring(2, length + 2);
}

export function useInputId(id?: string): string {
  const random = useMemo(() => randomId(), []);
  return id || random;
}
