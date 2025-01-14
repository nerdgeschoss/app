import React, { ReactNode } from 'react';

import { FormField } from '../form_field/form_field';
import { TextField } from '../text_field/text_field';

interface Props extends FormField<number> {
  label?: ReactNode;
}

export function NumberField(props: Props): JSX.Element {
  return (
    <TextField
      {...props}
      value={props.value.toString()}
      onChange={(value) => props.onChange?.(Number(value))}
    />
  );
}
