import React from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { Stack } from '../../frontend/components/stack/stack';
import { Button } from '../../frontend/components/button/button';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { TextField } from '../../frontend/components/text_field/text_field';
import { DateField } from '../../frontend/components/date_field/date_field';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useModalInfo } from '../../frontend/components/modal/modal';
import { NumberField } from '../../frontend/components/number_field/number_field';
import { Form } from '../../frontend/components/form/form';
import { handleError } from '../../frontend/util/errors';
import { Box } from '../../frontend/components/box/box';

export default function ({
  data: { sprint },
}: PageProps<'sprints/new'>): JSX.Element {
  const l = useFormatter();
  const t = useTranslate();
  const reaction = useReaction();
  const modal = useModalInfo();
  const { fields, valid, onSubmit } = useForm({
    model: {
      title: '',
      sprintFrom: l.parseRequiredDate(sprint.sprintFrom),
      sprintUntil: l.parseRequiredDate(sprint.sprintUntil),
      workingDays: sprint.workingDays,
    },
    validations: {
      title: 'required',
      sprintFrom: 'required',
      sprintUntil: 'required',
      workingDays: 'required',
    },
    onSubmit: async ({ model }) => {
      await reaction.call({
        path: '/sprints',
        method: 'POST',
        params: { sprint: model },
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
          <TextField {...fields.title} label={t('sprints.new.title')} />
          <DateField
            {...fields.sprintFrom}
            label={t('sprints.new.sprint_from')}
          />
          <DateField
            {...fields.sprintUntil}
            label={t('sprints.new.sprint_until')}
          />
          <NumberField
            {...fields.workingDays}
            label={t('sprints.new.working_days')}
          />
          <Button
            title={t('sprints.new.save')}
            disabled={!valid}
            onClick={onSubmit}
          />
        </Stack>
      </Form>
    </Box>
  );
}
