import React, { useState } from 'react';
import { PageProps } from '../../../data.d';
import { Button } from '../../frontend/components/button/button';
import { Stack } from '../../frontend/components/stack/stack';
import { TextField } from '../../frontend/components/text_field/text_field';
import { Container } from '../../frontend/components/container/container';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Form } from '../../frontend/components/form/form';
import { handleError } from '../../frontend/util/errors';
import { Card } from '../../frontend/components/card/card';

export default function EditSession({
  data: { email },
}: PageProps<'sessions/edit'>): JSX.Element {
  const reaction = useReaction();
  const [invalidCode, setInvalidCode] = useState(false);
  const { fields, onSubmit } = useForm({
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
    onSubmitError: handleError,
  });

  return (
    <Container>
      <Card title="Login" type="login-card">
        <Form onSubmit={onSubmit}>
          <Stack>
            <TextField {...fields.email} label="Email" disabled />
            <TextField
              {...fields.code}
              label="Code"
              onChange={(value) => {
                setInvalidCode(false);
                fields.code.onChange(value);
              }}
              errors={[
                ...fields.code.errors,
                ...(invalidCode ? ['invalid-code'] : []),
              ]}
            />
            <Button title="Login" onClick={onSubmit} />
          </Stack>
        </Form>
      </Card>
    </Container>
  );
}
