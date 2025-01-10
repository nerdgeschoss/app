import React from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter } from '../../javascript/util/dependencies';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { PerformanceGrid } from '../../javascript/components/performance_grid/performance_grid';
import { Performance } from '../../javascript/components/performance/performance';
import { Card } from '../../javascript/components/card/card';
import { Button } from '../../javascript/components/button/button';
import { useModal } from '../../javascript/components/modal/modal';
import { useReaction } from '../../javascript/sprinkles/reaction';

export default function ({
  data: { currentUser, sprints, nextPageUrl },
}: PageProps<'sprints/index'>): JSX.Element {
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="headline">Sprints</Text>
          <Button title="add" onClick={() => modal.present('/sprints/new')} />
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
