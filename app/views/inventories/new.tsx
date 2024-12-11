import { useForm } from '@nerdgeschoss/react-use-form-library';
import React from 'react';
import { PageProps } from '../../../data.d';
import { TextField } from '../../javascript/components/text_field/text_field';
import { DateField } from '../../javascript/components/date_field/date_field';
import { Button } from '../../javascript/components/button/button';
import { useModalInfo } from '../../javascript/components/modal/modal';

interface Form {
  userId: string;
  name: string;
  details: string;
  receivedAt: Date | null;
}

export default function ({
  data: { user },
}: PageProps<'inventories/new'>): JSX.Element {
  const modal = useModalInfo();
  const { fields, onSubmit } = useForm<Form>({
    model: { userId: user.id, name: '', details: '', receivedAt: null },
    validations: {
      name: 'required',
      receivedAt: 'required',
    },
    onSubmit: ({ model }) => {
      console.log('submitting', model);
      modal.close();
    },
  });
  return (
    <div className="container">
      <TextField {...fields.name} label="Name" />
      <TextField {...fields.details} label="Details" />
      <DateField {...fields.receivedAt} label="Received at" />
      <Button title="create" onClick={onSubmit} />
    </div>
  );
}
