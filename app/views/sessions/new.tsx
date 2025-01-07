import React from 'react';
import { Button } from '../../javascript/components/button/button';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { TextField } from '../../javascript/components/text_field/text_field';
import { Container } from '../../javascript/components/container/container';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useReaction } from '../../javascript/sprinkles/reaction';

export default function NewSession(): JSX.Element {
  const reaction = useReaction();
  const { fields, valid, onSubmit } = useForm({
    model: { email: '' },
    validations: { email: 'required' },
    onSubmit: async ({ model }) => {
      await reaction.call({
        path: '/en/login',
        method: 'POST',
        params: model,
        refresh: false,
      });
    },
  });
  return (
    <Container>
      <Stack>
        <Text type="headline">Login</Text>
        <TextField {...fields.email} label="Email" />
        <Button title="Login" disabled={!valid} onClick={onSubmit} />
      </Stack>
    </Container>
  );
}
