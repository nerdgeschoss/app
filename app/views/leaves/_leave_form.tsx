import { JSX, ReactNode } from 'react';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { CalendarField } from '../../frontend/components/calendar_field/calendar_field';
import { TextField } from '../../frontend/components/text_field/text_field';
import { SelectField } from '../../frontend/components/select_field/select_field';
import { Button } from '../../frontend/components/button/button';
import { SelectOption } from '../../frontend/components/form_field/form_field';
import { Text } from '../../frontend/components/text/text';
import { Form } from '../../frontend/components/form/form';
import { handleError } from '../../frontend/util/errors';
import { Box } from '../../frontend/components/box/box';
import { Stack } from '../../frontend/components/stack/stack';

export type LeaveType = 'paid' | 'sick' | 'non_working';

export interface LeaveFormValues {
  days: Date[];
  title: string;
  type: LeaveType;
}

interface Props {
  initialValues: LeaveFormValues;
  berlinHolidays: Array<{ name: string; date: string }>;
  submitLabel: string;
  hint?: ReactNode;
  onSubmit: (model: LeaveFormValues) => Promise<void>;
}

export function LeaveForm({
  initialValues,
  berlinHolidays,
  submitLabel,
  hint,
  onSubmit,
}: Props): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const { fields, onSubmit: submit } = useForm<LeaveFormValues>({
    model: initialValues,
    validations: {
      days: ({ model }) =>
        (model.days?.length ?? 0) === 0 ? ['required-field'] : [],
      title: 'required',
      type: 'required',
    },
    onSubmit: ({ model }) => onSubmit(model),
    onSubmitError: handleError,
  });
  const leaveTypes: SelectOption<LeaveType>[] = [
    { value: 'paid', label: t('leaves.form.pto') },
    { value: 'sick', label: t('leaves.form.sick') },
    { value: 'non_working', label: t('leaves.form.not_working') },
  ];

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const someDaysInPast = fields.days.value.some((date) => date < today);

  const sortedDays = [...fields.days.value].sort(
    (a, b) => a.getTime() - b.getTime()
  );
  const range = sortedDays.length
    ? l.dateRange(sortedDays[0], sortedDays[sortedDays.length - 1])
    : null;

  return (
    <Box size={24}>
      <Form onSubmit={submit}>
        <Stack>
          <Text type="h5-bold">{t('leaves.form.title')}</Text>
          <Stack line="mobile" justify="space-between" align="center">
            <Text type="caption-primary-bold">{t('leaves.form.days')}</Text>
            {range && <Text>{range}</Text>}
          </Stack>
          <CalendarField
            {...fields.days}
            disabledDates={berlinHolidays.map((holiday) => holiday.date)}
          />
          {someDaysInPast && (
            <Text>{t('leaves.form.days_in_past_warning')}</Text>
          )}
          <SelectField
            {...fields.type}
            label={t('leaves.form.leave_type')}
            options={leaveTypes}
          />
          <TextField {...fields.title} label={t('leaves.form.leave_title')} />
          {hint && <Text>{hint}</Text>}
          <Stack line="mobile" justify="right">
            <Button title={submitLabel} onClick={submit} />
          </Stack>
        </Stack>
      </Form>
    </Box>
  );
}
