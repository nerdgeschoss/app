import { PageProps } from '../../../data.d';
import { useTranslate } from '../../frontend/util/dependencies';
import { handleError } from '../../frontend/util/errors';
import { Button } from '../../frontend/components/button/button';
import { TextArea } from '../../frontend/components/text_area/text_area';
import { useForm } from '@nerdgeschoss/react-use-form-library';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useModalInfo } from '../../frontend/components/modal/modal';
import { Checkbox } from '../../frontend/components/checkbox/checkbox';
import { Box } from '../../frontend/components/box/box';
import { Text } from '../../frontend/components/text/text';
import { CollapsePanel } from '../../frontend/components/collapse_panel/collapse_panel';
import { StarField } from '../../frontend/components/star_field/star_field';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';

export default function ({
  data: { feedback },
}: PageProps<'sprint_feedbacks/edit_retro'>): JSX.Element {
  const t = useTranslate();
  const reaction = useReaction();
  const modal = useModalInfo();
  const { fields, onSubmit } = useForm({
    model: {
      retroRating: feedback.retroRating ?? 5,
      retroText: feedback.retroText ?? '',
      skipRetro: feedback.skipRetro,
    },
    validations: {
      retroRating: ({ model }) =>
        model.skipRetro || model.retroRating ? [] : ['required-field'],
      retroText: ({ model }) =>
        model.skipRetro || model.retroText ? [] : ['required-field'],
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
    onSubmitError: (error) => handleError(error),
  });

  return (
    <Box size={24} sizeHorizontal={32}>
      <Stack gap={16}>
        <Text>{t('sprint_feedbacks.edit_retro.headline')}</Text>
        <Checkbox
          {...fields.skipRetro}
          label={t('sprint_feedbacks.edit_retro.skip')}
        />
        <CollapsePanel open={!fields.skipRetro.value}>
          <Stack gap={16}>
            <StarField
              {...fields.retroRating}
              inputId="retro-rating"
              label={t('sprint_feedbacks.edit_retro.rating')}
            />
            <TextArea
              {...fields.retroText}
              label={t('sprint_feedbacks.edit_retro.text')}
            />
          </Stack>
        </CollapsePanel>
        <Button
          title={t('sprint_feedbacks.edit_retro.save')}
          onClick={onSubmit}
        />
      </Stack>
    </Box>
  );
}
