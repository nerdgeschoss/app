import React from 'react';
import { Button } from '../../frontend/components/button/button';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { TextField } from '../../frontend/components/text_field/text_field';
import { Container } from '../../frontend/components/container/container';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Form } from '../../frontend/components/form/form';
import { handleError } from '../../frontend/util/errors';

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
    onSubmitError: handleError,
  });
  return (
    <Container>
      <Form onSubmit={onSubmit}>
        <Stack>
          <Text type="headline">Login</Text>
          <TextField {...fields.email} label="Email" />
          <Button title="Login" disabled={!valid} onClick={onSubmit} />
        </Stack>
      </Form>
    </Container>
  );
}
