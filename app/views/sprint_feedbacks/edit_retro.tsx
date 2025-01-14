import React from 'react';
import { PageProps } from '../../../data.d';
import { useTranslate } from '../../frontend/util/dependencies';
import { Stack } from '../../frontend/components/stack/stack';
import { Button } from '../../frontend/components/button/button';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { TextField } from '../../frontend/components/text_field/text_field';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useModalInfo } from '../../frontend/components/modal/modal';
import { NumberField } from '../../frontend/components/number_field/number_field';
import { Checkbox } from '../../frontend/components/checkbox/checkbox';

export default function ({
  data: { feedback },
}: PageProps<'sprint_feedbacks/edit_retro'>): JSX.Element {
  const t = useTranslate();
  const reaction = useReaction();
  const modal = useModalInfo();
  const { fields, valid, onSubmit } = useForm({
    model: {
      retroRating: feedback.retroRating ?? 5,
      retroText: feedback.retroText ?? '',
      skipRetro: feedback.skipRetro,
    },
    validations: {
      retroRating: ({ model }) =>
        model.skipRetro || model.retroRating ? [] : ['required'],
      retroText: ({ model }) =>
        model.skipRetro || model.retroText ? [] : ['required'],
    },
    onSubmit: async ({ model }) => {
      const sprint_feedback = model.skipRetro
        ? { skipRetro: true, retroText: null, retroRating: null }
        : {
            skipRetro: false,
            retroText: model.retroText,
            retroRating: model.retroRating,
          };
      await reaction.call({
        path: `/sprint_feedbacks/${feedback.id}/update_retro`,
        method: 'POST',
        params: { sprint_feedback },
        refresh: true,
      });
      modal.close();
    },
  });

  return (
    <Stack>
      <Checkbox
        {...fields.skipRetro}
        label={t('sprint_feedbacks.edit_retro.skip')}
      />
      {!fields.skipRetro.value && (
        <>
          <NumberField
            {...fields.retroRating}
            label={t('sprint_feedbacks.edit_retro.rating')}
          />
          <TextField
            {...fields.retroText}
            label={t('sprint_feedbacks.edit_retro.text')}
          />
        </>
      )}
      <Button
        title={t('sprint_feedbacks.edit_retro.save')}
        disabled={!valid}
        onClick={onSubmit}
      />
    </Stack>
  );
}
