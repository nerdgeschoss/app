import { useForm } from '@nerdgeschoss/react-use-form-library';
import React from 'react';
import { PageProps } from '../../../data.d';
import { TextField } from '../../frontend/components/text_field/text_field';
import { Button } from '../../frontend/components/button/button';
import { useModalInfo } from '../../frontend/components/modal/modal';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { DateField } from '../../frontend/components/date_field/date_field';
import { Form } from '../../frontend/components/form/form';
import { handleError } from '../../frontend/util/errors';
import { Box } from '../../frontend/components/box/box';
import { Stack } from '../../frontend/components/stack/stack';

interface Form {
  name: string;
  details: string;
  receivedAt: Date;
  returnedAt: Date | null;
}

export default function ({
  data: { inventory },
}: PageProps<'inventories/edit'>): JSX.Element {
  const modal = useModalInfo();
  const reaction = useReaction();
  const t = useTranslate();
  const l = useFormatter();
  const { fields, onSubmit, valid } = useForm<Form>({
    model: {
      name: inventory.name,
      details: inventory.details ?? '',
      receivedAt: l.parseRequiredDate(inventory.receivedAt),
      returnedAt: l.parseDate(inventory.returnedAt),
    },
    validations: {
      name: 'required',
      receivedAt: 'required',
    },
    onSubmit: async ({ changes }) => {
      await reaction.call({
        path: `/inventories/${inventory.id}`,
        method: 'PATCH',
        params: { inventory: changes },
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
          <TextField {...fields.name} label={t('inventories.edit.name')} />
          <TextField
            {...fields.details}
            label={t('inventories.edit.details')}
          />
          <DateField
            {...fields.receivedAt}
            label={t('inventories.edit.received_at')}
          />
          <DateField
            {...fields.returnedAt}
            label={t('inventories.edit.returned_at')}
          />
          <Stack line="mobile">
            <Button
              title={t('inventories.edit.save')}
              disabled={!valid}
              onClick={onSubmit}
            />
            <Button
              title={t('inventories.edit.delete')}
              onClick={async () => {
                await reaction.call({
                  path: `/inventories/${inventory.id}`,
                  method: 'DELETE',
                  refresh: true,
                });
                modal.close();
              }}
            />
          </Stack>
        </Stack>
      </Form>
    </Box>
  );
}
