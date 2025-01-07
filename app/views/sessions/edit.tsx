import React, { useState } from 'react';
import { PageProps } from '../../../data.d';
import { Button } from '../../javascript/components/button/button';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { TextField } from '../../javascript/components/text_field/text_field';
import { Container } from '../../javascript/components/container/container';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useReaction } from '../../javascript/sprinkles/reaction';

export default function EditSession({
  data: { email },
}: PageProps<'sessions/edit'>): JSX.Element {
  const reaction = useReaction();
  const [invalidCode, setInvalidCode] = useState(false);
  const { fields, valid, onSubmit } = useForm({
    model: { email, code: '' },
    validations: { email: 'required', code: 'required' },
    onSubmit: async ({ model }) => {
      try {
        await reaction.call({
          path: '/en/confirm_login',
          method: 'POST',
          params: model,
        });
      } catch {
        setInvalidCode(true);
      }
    },
  });
  return (
    <Container>
      <Stack>
        <Text type="headline">Login</Text>
        <TextField {...fields.email} label="Email" disabled />
        <TextField
          {...fields.code}
          label="Code"
          errors={[
            ...fields.code.errors,
            ...(invalidCode ? ['invalid-code'] : []),
          ]}
        />
        <Button title="Login" disabled={!valid} onClick={onSubmit} />
      </Stack>
    </Container>
  );
}
