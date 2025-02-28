import React from 'react';
import { Card } from '../../frontend/components/card/card';
import { TextArea } from '../../frontend/components/text_area/text_area';
import { Button } from '../../frontend/components/button/button';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useReaction } from '../../frontend/sprinkles/reaction';

interface Props {
  id: string | null;
  message: string | null;
}

export function DailyNerdCard({ id, message }: Props): JSX.Element {
  const reaction = useReaction();
  const { fields, onSubmit } = useForm({
    model: { message: message || '' },
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
    },
  });
  return (
    <Card
      title="Daily Nerd"
      icon="📝"
      subtitle={
        <>
          <TextArea
            {...fields.message}
            label="Message"
            placeholder="How was your day? What did you learn?"
          />
          <Button
            title={
              id ? 'Update daily nerd message' : 'Create daily nerd message'
            }
            onClick={onSubmit}
          />
        </>
      }
    />
  );
}
