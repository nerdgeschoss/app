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
import { Property } from '../../frontend/components/property/property';

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
          <Text type="h1-bold">Sprints</Text>
          {permitCreateSprint && (
            <Button title="add" onClick={() => modal.present('/sprints/new')} />
          )}
        </Stack>
        <Stack size={32}>
          {sprints.map((sprint) => (
            <Stack key={sprint.id}>
              <Stack line="mobile" align="center">
                <Text type="h3-bold">🏃 {sprint.title}</Text>
                <Text type="h4-regular" color="label-heading-secondary">
                  {l.dateRange(sprint.sprintFrom, sprint.sprintUntil)}
                </Text>
              </Stack>
              <Card
                subtitle={
                  <Stack line="mobile" wrap justify="space-between">
                    <Stack line="mobile" fullWidth={'none'} wrap>
                      <div>
                        <Property
                          prefix="🔢"
                          value={sprint.finishedStorypoints}
                          suffix="pts"
                        />
                      </div>
                      <div>
                        <Property
                          prefix="🔢"
                          value={l.singleDigitNumber(
                            sprint.finishedStorypointsPerDay
                          )}
                          suffix="pts/day"
                        />
                      </div>
                      <div>
                        <Property
                          prefix="⭐️"
                          value={l.singleDigitNumber(sprint.averageRating)}
                          suffix="/5"
                        />
                      </div>
                      <div>
                        <Property
                          prefix="💻"
                          value={sprint.totalWorkingDays}
                          suffix="days"
                        />
                      </div>
                    </Stack>
                    <Stack
                      line="mobile"
                      justifyDesktop="right"
                      fullWidth={'none'}
                      wrap
                    >
                      {sprint.turnoverPerStorypoint !== null && (
                        <div>
                          <Property
                            prefix="💸"
                            value={l.singleDigitNumber(
                              sprint.turnoverPerStorypoint
                            )}
                            suffix="per point"
                          />
                        </div>
                      )}
                      {sprint.turnover !== null && (
                        <div>
                          <Property
                            prefix="💰"
                            value={l.currency(sprint.turnover)}
                            suffix="Monthly total"
                          />
                        </div>
                      )}
                    </Stack>
                  </Stack>
                }
              >
                <PerformanceGrid>
                  {sprint.performances.map((performance) => (
                    <Performance key={performance.id} {...performance} />
                  ))}
                </PerformanceGrid>
              </Card>
            </Stack>
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
