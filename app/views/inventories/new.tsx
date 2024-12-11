import { useForm } from '@nerdgeschoss/react-use-form-library';
import React from 'react';
import { PageProps } from '../../../data.d';
import { TextField } from '../../javascript/components/text_field/text_field';
import { Button } from '../../javascript/components/button/button';
import { DatetimeField } from '../../javascript/components/datetime_field/datetime_field';
import { useModalInfo } from '../../javascript/components/modal/modal';
import { useReaction } from '../../javascript/sprinkles/reaction';

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
      });
      console.log('submitting', model);
      await reaction.history.refreshPageContent();
      modal.close();
    },
  });
  return (
    <div className="container">
      <TextField {...fields.name} label="Name" />
      <TextField {...fields.details} label="Details" />
      <DatetimeField {...fields.receivedAt} label="Received at" />
      <Button title="create" disabled={!valid} onClick={onSubmit} />
    </div>
  );
}
