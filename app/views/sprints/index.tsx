import { JSX } from 'react';
import { PageProps } from '../../../data.d';
import { useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { Button } from '../../frontend/components/button/button';
import { useModal } from '../../frontend/components/modal/modal';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { SprintCard } from './_sprint_card';

export default function ({
  data: { currentUser, sprints, nextPageUrl, permitCreateSprint },
}: PageProps<'sprints/index'>): JSX.Element {
  const t = useTranslate();
  const reaction = useReaction();
  const modal = useModal();
  const isHr =
    currentUser.roles.includes('hr') || currentUser.roles.includes('admin');
  const displayModes = isHr
    ? (['performance', 'retro', 'points', 'profits'] as const)
    : (['performance', 'retro', 'points'] as const);

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="h1-bold">{t('sprints.index.title')}</Text>
          {permitCreateSprint && (
            <Button
              title={t('sprints.index.create_sprint')}
              onClick={() => modal.present('/sprints/new')}
            />
          )}
        </Stack>
        <Stack size={32}>
          {sprints.map((sprint) => (
            <SprintCard
              key={sprint.id}
              sprint={sprint}
              displayModes={displayModes}
            />
          ))}
          {nextPageUrl && (
            <Button
              title={t('sprints.index.more')}
              onClick={() =>
                reaction.history.extendPageContentWithPagination(
                  nextPageUrl,
                  'sprints'
                )
              }
            />
          )}
        </Stack>
      </Stack>
    </Layout>
  );
}
