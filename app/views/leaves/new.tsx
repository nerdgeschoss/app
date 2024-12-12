import React from 'react';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';
import { Layout } from '../../javascript/components/layout/layout';
import { CalendarField } from '../../javascript/components/calendar_field/calendar_field';
import { TextField } from '../../javascript/components/text_field/text_field';
import { SelectField } from '../../javascript/components/select_field/select_field';
import { Button } from '../../javascript/components/button/button';
import { useReaction } from '../../javascript/sprinkles/reaction';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useModalInfo } from '../../javascript/components/modal/modal';
import { SelectOption } from '../../javascript/components/form_field/form_field';
import { Text } from '../../javascript/components/text/text';

interface Form {
  userId: string;
  days: Date[];
  title: string;
  type: 'paid' | 'sick' | 'not_working';
}

export default function ({
  data: { permitUserSelect, users, currentUser },
}: PageProps<'leaves/new'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModalInfo();
  const { fields, onSubmit, valid, model } = useForm<Form>({
    model: {
      userId: currentUser.id,
      days: [],
      title: '',
      type: 'paid',
    },
    validations: {
      userId: 'required',
      days: ({ model }) => ((model.days?.length ?? 0) == 0 ? ['required'] : []),
      title: 'required',
      type: 'required',
    },
    onSubmit: async ({ model }) => {
      await reaction.call({
        path: '/leaves',
        method: 'POST',
        params: { leave: model },
      });
      modal.close();
    },
  });
  const leaveTypes: SelectOption<Form['type']>[] = [
    { value: 'paid', label: 'Paid' },
    { value: 'sick', label: 'Sick' },
    { value: 'not_working', label: 'Not Working' },
  ];
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const someDaysInPast = fields.days.value.some((date) => date < today);
  console.log('model', model);

  return (
    <>
      <CalendarField {...fields.days} label="Days" />
      {someDaysInPast && <Text>{t('leaves.new.days_in_past_warning')}</Text>}
      {permitUserSelect && (
        <SelectField
          {...fields.userId}
          label="User"
          options={users.map((user) => ({
            value: user.id,
            label: user.displayName,
          }))}
        />
      )}
      <TextField {...fields.title} label="Title" />
      <SelectField {...fields.type} label="Type" options={leaveTypes} />
      <Button title="create" disabled={!valid} onClick={onSubmit} />
    </>
  );
}
