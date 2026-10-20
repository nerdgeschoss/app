import { JSX } from 'react';
import { PageProps } from '../../../data.d';
import { useTranslate } from '../../frontend/util/dependencies';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useModalInfo } from '../../frontend/components/modal/modal';
import { isoDate } from '../../frontend/util/date';
import { LeaveForm, LeaveType } from './_leave_form';

export default function ({
  data: { berlinHolidays, leave },
}: PageProps<'leaves/edit'>): JSX.Element {
  const t = useTranslate();
  const reaction = useReaction();
  const modal = useModalInfo();

  return (
    <LeaveForm
      initialValues={{
        days: leave.days.map((day) => new Date(day.day)),
        title: leave.title,
        type: leave.type as LeaveType,
      }}
      berlinHolidays={berlinHolidays}
      submitLabel={t('leaves.form.save')}
      hint={
        leave.status === 'approved' ? t('leaves.form.approved_hint') : undefined
      }
      onSubmit={async (model) => {
        await reaction.call({
          path: `/leaves/${leave.id}`,
          method: 'PATCH',
          params: { leave: { ...model, days: model.days.map(isoDate) } },
          refresh: true,
        });
        modal.close();
      }}
    />
  );
}
