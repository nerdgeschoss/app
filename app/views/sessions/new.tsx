import React from 'react';
import { Button } from '../../frontend/components/button/button';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';
import { TextField } from '../../frontend/components/text_field/text_field';
import { Container } from '../../frontend/components/container/container';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Form } from '../../frontend/components/form/form';
import { handleError } from '../../frontend/util/errors';
import { Card } from '../../frontend/components/card/card';
import { Logo } from '../../frontend/components/logo/logo';

export default function NewSession(): JSX.Element {
  const reaction = useReaction();
  const { fields, onSubmit } = useForm({
    model: { email: '' },
    validations: { email: ['required', 'email'] },
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
      <Stack gap={32} align="center">
        <Logo />
        <Card title="Login" type="login-card">
          <Form onSubmit={onSubmit}>
            <Stack gap={16}>
              <TextField {...fields.email} label="Email" autoComplete="email" />
              <Button title="Login" onClick={onSubmit} />
            </Stack>
          </Form>
        </Card>
      </Stack>
    </Container>
  );
}
