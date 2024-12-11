import { useForm } from '@nerdgeschoss/react-use-form-library';
import React from 'react';
import { PageProps } from '../../../data.d';
import { Button } from '../../javascript/components/button/button';
import { DateField } from '../../javascript/components/date_field/date_field';
import { useModalInfo } from '../../javascript/components/modal/modal';
import { SelectField } from '../../javascript/components/select_field/select_field';
import { FileField } from '../../javascript/components/file_field/file_field';
import { useReaction } from '../../javascript/sprinkles/reaction';
import { useFormatter } from '../../javascript/util/dependencies';

interface Form {
  userId: string;
  month: Date;
  pdf: File | null;
}

export default function ({
  data: { users, defaultMonth },
}: PageProps<'payslips/new'>): JSX.Element {
  const modal = useModalInfo();
  const reaction = useReaction();
  const l = useFormatter();
  const { fields, onSubmit, valid } = useForm<Form>({
    model: {
      userId: users[0]?.id,
      month: l.parseDate(defaultMonth)!,
      pdf: null,
    },
    validations: {
      userId: 'required',
      month: 'required',
      pdf: 'required',
    },
    onSubmit: async ({ model }) => {
      await reaction.call({
        path: '/payslips',
        method: 'POST',
        params: { payslip: model },
      });
      modal.close();
    },
  });
  return (
    <>
      <SelectField
        {...fields.userId}
        label="User"
        options={users.map((user) => ({
          value: user.id,
          label: user.displayName,
        }))}
      />
      <DateField {...fields.month} label="Received at" />
      <FileField {...fields.pdf} label="File" />
      <Button title="create" disabled={!valid} onClick={onSubmit} />
    </>
  );
}
