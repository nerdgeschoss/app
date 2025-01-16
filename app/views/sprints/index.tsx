import React from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { PerformanceGrid } from '../../frontend/components/performance_grid/performance_grid';
import { Performance } from '../../frontend/components/performance/performance';
import { Card } from '../../frontend/components/card/card';
import { Button } from '../../frontend/components/button/button';
import { useModal } from '../../frontend/components/modal/modal';
import { useReaction } from '../../frontend/sprinkles/reaction';

export default function ({
  data: { currentUser, sprints, nextPageUrl, permitCreateSprint },
}: PageProps<'sprints/index'>): JSX.Element {
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="headline">Sprints</Text>
          {permitCreateSprint && (
            <Button title="add" onClick={() => modal.present('/sprints/new')} />
          )}
        </Stack>
        <Stack>
          {sprints.map((sprint) => (
            <Card
              key={sprint.id}
              title={sprint.title}
              icon="🏃"
              subtitle={l.dateRange(sprint.sprintFrom, sprint.sprintUntil)}
            >
              <PerformanceGrid>
                {sprint.performances.map((performance) => (
                  <Performance key={performance.id} {...performance} />
                ))}
              </PerformanceGrid>
            </Card>
          ))}
          {nextPageUrl && (
            <Button
              title="more"
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
