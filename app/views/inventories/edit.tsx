import { useForm } from '@nerdgeschoss/react-use-form-library';
import React from 'react';
import { PageProps } from '../../../data.d';
import { TextField } from '../../javascript/components/text_field/text_field';
import { Button } from '../../javascript/components/button/button';
import { DatetimeField } from '../../javascript/components/datetime_field/datetime_field';
import { useModalInfo } from '../../javascript/components/modal/modal';
import { useReaction } from '../../javascript/sprinkles/reaction';
import { Container } from '../../javascript/components/container/container';
import { useFormatter } from '../../javascript/util/dependencies';

interface Form {
  name: string;
  details: string;
  receivedAt: Date;
}

export default function ({
  data: { inventory },
}: PageProps<'inventories/edit'>): JSX.Element {
  const modal = useModalInfo();
  const reaction = useReaction();
  const l = useFormatter();
  const { fields, onSubmit, valid } = useForm<Form>({
    model: {
      name: inventory.name,
      details: inventory.details ?? '',
      receivedAt: l.parseDate(inventory.receivedAt) ?? new Date(),
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
      });
      modal.close();
    },
  });
  return (
    <Container>
      <TextField {...fields.name} label="Name" />
      <TextField {...fields.details} label="Details" />
      <DatetimeField {...fields.receivedAt} label="Received at" />
      <Button title="update" disabled={!valid} onClick={onSubmit} />
      <Button
        title="delete"
        onClick={async () => {
          await reaction.call({
            path: `/inventories/${inventory.id}`,
            method: 'DELETE',
          });
          modal.close();
        }}
      />
    </Container>
  );
}
