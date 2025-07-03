import React from 'react';
import { Card } from '../../frontend/components/card/card';
import { TextArea } from '../../frontend/components/text_area/text_area';
import { Button } from '../../frontend/components/button/button';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';
import { Form } from '../../frontend/components/form/form';
import { Text } from '../../frontend/components/text/text';

interface Props {
  id: string | null;
  message: string | null;
}

export function DailyNerdCard({ id, message }: Props): JSX.Element {
  const reaction = useReaction();
  const [editMode, setEditMode] = React.useState(!id);

  const { fields, onSubmit } = useForm({
    model: { message: message || '' },
    validations: {
      message: 'required',
    },
    onSubmit: async ({ model }) => {
      if (id) {
        await reaction.call({
          path: `/daily_nerd_messages/${id}`,
          method: 'PATCH',
          params: { daily_nerd_message: model },
          refresh: true,
        });
      } else {
        await reaction.call({
          path: '/daily_nerd_messages',
          method: 'POST',
          params: { daily_nerd_message: model },
          refresh: true,
        });
      }
      setEditMode(false);
    },
  });

  return (
    <Card title="Daily Nerd" icon="📝">
      {!editMode ? (
        <Stack gap={24} align="end">
          <Text type="label-body-primary" block>
            Message:
          </Text>
          <Text block>{message}</Text>
          <Button title="Update daily nerd" onClick={() => setEditMode(true)} />
        </Stack>
      ) : (
        <Form onSubmit={onSubmit}>
          <Stack gap={24} align="end">
            <TextArea
              {...fields.message}
              label="Message"
              placeholder="How was your day? What did you learn?"
            />
            <Button title="Submit daily nerd" disablePreventDefault />
          </Stack>
        </Form>
      )}
    </Card>
  );
}
