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
