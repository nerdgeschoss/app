import React, { useState } from 'react';
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
import { Pill } from '../../frontend/components/pill/pill';

export default function ({
  data: { currentUser, sprints, nextPageUrl, permitCreateSprint },
}: PageProps<'sprints/index'>): JSX.Element {
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();
  const [displayMode, setDisplayMode] = useState<
    'performance' | 'retro' | 'points'
  >('performance');

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
                  {l.dateRangeLong(sprint.sprintFrom, sprint.sprintUntil)}
                </Text>
              </Stack>
              <Card
                withDivider
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
                <Stack size={16}>
                  <Stack line="mobile" size={4}>
                    {(['performance', 'retro', 'points'] as const).map((e) => (
                      <div onClick={() => setDisplayMode(e)} key={e}>
                        <Pill active={e === displayMode}>{e}</Pill>
                      </div>
                    ))}
                  </Stack>
                  {displayMode === 'performance' && (
                    <PerformanceGrid>
                      {sprint.performances.map((performance) => (
                        <Performance key={performance.id} {...performance} />
                      ))}
                    </PerformanceGrid>
                  )}
                  {displayMode === 'retro' && (
                    <Stack>
                      {sprint.retroNotes.map((retro) => (
                        <Stack key={retro.id}>
                          <Stack line="mobile">
                            <Text type="card-heading-bold">
                              {retro.user.displayName}
                            </Text>
                            <Stack line="mobile" size={8}>
                              <span>⭐</span>
                              <Text type="caption-primary-regular">
                                {retro.retroRating ?? '-'}
                              </Text>
                            </Stack>
                          </Stack>
                          {retro.retroText && (
                            <Text multiline type="body-regular">
                              {retro.retroText}
                            </Text>
                          )}
                        </Stack>
                      ))}
                    </Stack>
                  )}
                  {displayMode === 'points' && (
                    <Stack>
                      {sprint.storypointsPerDepartment.map((points) => (
                        <Stack
                          key={points.team}
                          line="mobile"
                          justify="space-between"
                        >
                          <Text type="body-regular">{points.team}</Text>
                          <Text type="body-regular">
                            {l.singleDigitNumber(points.points)} pts
                          </Text>
                          <Text type="body-regular">
                            {points.workingDays} days
                          </Text>
                          <Text type="body-regular">
                            {l.singleDigitNumber(points.pointsPerWorkingDay)}{' '}
                            pts/day
                          </Text>
                        </Stack>
                      ))}
                      <Stack line="mobile" justify="space-between">
                        <Text type="body-regular">Total</Text>
                        <Text type="body-regular">
                          {l.singleDigitNumber(
                            sprint.storypointsPerDepartment.reduce(
                              (acc, points) => acc + points.points,
                              0
                            )
                          )}{' '}
                          pts
                        </Text>
                        <Text type="body-regular"> </Text>
                        <Text type="body-regular"> </Text>
                      </Stack>
                    </Stack>
                  )}
                </Stack>
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
