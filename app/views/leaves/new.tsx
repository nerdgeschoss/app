import React from 'react';
import { PageProps } from '../../../data.d';
import { useTranslate } from '../../frontend/util/dependencies';
import { CalendarField } from '../../frontend/components/calendar_field/calendar_field';
import { TextField } from '../../frontend/components/text_field/text_field';
import { SelectField } from '../../frontend/components/select_field/select_field';
import { Button } from '../../frontend/components/button/button';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useModalInfo } from '../../frontend/components/modal/modal';
import { SelectOption } from '../../frontend/components/form_field/form_field';
import { Text } from '../../frontend/components/text/text';
import { Form } from '../../frontend/components/form/form';
import { handleError } from '../../frontend/util/errors';

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
  const reaction = useReaction();
  const modal = useModalInfo();
  const { fields, onSubmit, valid } = useForm<Form>({
    model: {
      userId: currentUser.id,
      days: [],
      title: '',
      type: 'paid',
    },
    validations: {
      userId: 'required',
      days: ({ model }) =>
        (model.days?.length ?? 0) === 0 ? ['required'] : [],
      title: 'required',
      type: 'required',
    },
    onSubmit: async ({ model }) => {
      await reaction.call({
        path: '/leaves',
        method: 'POST',
        params: { leave: model },
        refresh: true,
      });
      modal.close();
    },
    onSubmitError: handleError,
  });
  const leaveTypes: SelectOption<Form['type']>[] = [
    { value: 'paid', label: t('leaves.new.paid') },
    { value: 'sick', label: t('leaves.new.sick') },
    { value: 'not_working', label: t('leaves.new.not_working') },
  ];
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const someDaysInPast = fields.days.value.some((date) => date < today);

  return (
    <Form onSubmit={onSubmit}>
      <CalendarField {...fields.days} label={t('leaves.new.days')} />
      {someDaysInPast && <Text>{t('leaves.new.days_in_past_warning')}</Text>}
      {permitUserSelect && (
        <SelectField
          {...fields.userId}
          label={t('leaves.new.user')}
          options={users.map((user) => ({
            value: user.id,
            label: user.displayName,
          }))}
        />
      )}
      <TextField {...fields.title} label={t('leaves.new.title')} />
      <SelectField
        {...fields.type}
        label={t('leaves.new.type')}
        options={leaveTypes}
      />
      <Button
        title={t('leaves.new.request')}
        disabled={!valid}
        onClick={onSubmit}
      />
    </Form>
  );
}
