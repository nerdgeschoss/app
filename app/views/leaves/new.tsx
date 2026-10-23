import { JSX } from 'react';
import { PageProps } from '../../../data.d';
import { useTranslate } from '../../frontend/util/dependencies';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useModalInfo } from '../../frontend/components/modal/modal';
import { isoDate } from '../../frontend/util/date';
import { LeaveForm } from './_leave_form';

export default function ({
  data: { user, berlinHolidays },
}: PageProps<'leaves/new'>): JSX.Element {
  const t = useTranslate();
  const reaction = useReaction();
  const modal = useModalInfo();

  return (
    <LeaveForm
      initialValues={{ days: [], title: '', type: 'paid' }}
      berlinHolidays={berlinHolidays}
      submitLabel={t('leaves.form.request')}
      onSubmit={async (model) => {
        await reaction.call({
          path: `/users/${user.id}/leaves`,
          method: 'POST',
          params: { leave: { ...model, days: model.days.map(isoDate) } },
          refresh: true,
        });
        modal.close();
      }}
    />
  );
}
