import { JSX } from 'react';
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
import { Box } from '../../frontend/components/box/box';
import { Stack } from '../../frontend/components/stack/stack';
import { isoDate } from '../../frontend/util/date';

type LeaveType = 'paid' | 'sick' | 'non_working';

interface Form {
  days: Date[];
  title: string;
  type: LeaveType;
}

export default function ({
  data: { berlinHolidays, leave },
}: PageProps<'leaves/edit'>): JSX.Element {
  const t = useTranslate();
  const reaction = useReaction();
  const modal = useModalInfo();
  const { fields, onSubmit } = useForm<Form>({
    model: {
      days: leave.days.map((day) => new Date(day.day)),
      title: leave.title,
      type: leave.type as LeaveType,
    },
    validations: {
      days: ({ model }) =>
        (model.days?.length ?? 0) === 0 ? ['required-field'] : [],
      title: 'required',
      type: 'required',
    },
    onSubmit: async ({ model }) => {
      const params = {
        leave: {
          ...model,
          days: model.days.map(isoDate),
        },
      };
      await reaction.call({
        path: `/leaves/${leave.id}`,
        method: 'PATCH',
        params,
        refresh: true,
      });
      modal.close();
    },
    onSubmitError: handleError,
  });
  const leaveTypes: SelectOption<Form['type']>[] = [
    { value: 'paid', label: t('leaves.edit.paid') },
    { value: 'sick', label: t('leaves.edit.sick') },
    { value: 'non_working', label: t('leaves.edit.not_working') },
  ];

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const someDaysInPast = fields.days.value.some((date) => date < today);

  return (
    <Box size={24}>
      <Form onSubmit={onSubmit}>
        <Stack>
          <CalendarField
            {...fields.days}
            label={t('leaves.edit.days')}
            disabledDates={berlinHolidays.map((holiday) => holiday.date)}
          />
          {someDaysInPast && (
            <Text>{t('leaves.edit.days_in_past_warning')}</Text>
          )}
          <TextField {...fields.title} label={t('leaves.edit.title')} />
          <SelectField
            {...fields.type}
            label={t('leaves.edit.type')}
            options={leaveTypes}
          />
          <Button title={t('leaves.edit.request')} onClick={onSubmit} />
        </Stack>
      </Form>
    </Box>
  );
}
