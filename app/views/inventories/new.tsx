import { useForm } from '@nerdgeschoss/react-use-form-library';
import React from 'react';
import { PageProps } from '../../../data.d';
import { TextField } from '../../frontend/components/text_field/text_field';
import { Button } from '../../frontend/components/button/button';
import { DateField } from '../../frontend/components/date_field/date_field';
import { useModalInfo } from '../../frontend/components/modal/modal';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useTranslate } from '../../frontend/util/dependencies';
import { Form } from '../../frontend/components/form/form';
import { handleError } from '../../frontend/util/errors';
import { Box } from '../../frontend/components/box/box';
import { Stack } from '../../frontend/components/stack/stack';

interface Form {
  userId: string;
  name: string;
  details: string;
  receivedAt: Date;
}

export default function ({
  data: { user },
}: PageProps<'inventories/new'>): JSX.Element {
  const modal = useModalInfo();
  const reaction = useReaction();
  const t = useTranslate();
  const { fields, onSubmit, valid } = useForm<Form>({
    model: { userId: user.id, name: '', details: '', receivedAt: new Date() },
    validations: {
      name: 'required',
      receivedAt: 'required',
    },
    onSubmit: async ({ model }) => {
      await reaction.call({
        path: '/inventories',
        method: 'POST',
        params: { inventory: model },
        refresh: true,
      });
      modal.close();
    },
    onSubmitError: handleError,
  });
  return (
    <Box>
      <Form onSubmit={onSubmit}>
        <Stack>
          <TextField {...fields.name} label={t('inventories.new.name')} />
          <TextField {...fields.details} label={t('inventories.new.details')} />
          <DateField
            {...fields.receivedAt}
            label={t('inventories.new.received_at')}
          />
          <Button
            title={t('inventories.new.save')}
            disabled={!valid}
            onClick={onSubmit}
          />
        </Stack>
      </Form>
    </Box>
  );
}
