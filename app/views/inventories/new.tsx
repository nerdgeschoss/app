import { useForm } from '@nerdgeschoss/react-use-form-library';
import React from 'react';
import { PageProps } from '../../../data.d';
import { TextField } from '../../javascript/components/text_field/text_field';
import { Button } from '../../javascript/components/button/button';
import { DateField } from '../../javascript/components/date_field/date_field';
import { useModalInfo } from '../../javascript/components/modal/modal';
import { useReaction } from '../../javascript/sprinkles/reaction';
import { useTranslate } from '../../javascript/util/dependencies';

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
  });
  return (
    <>
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
    </>
  );
}
