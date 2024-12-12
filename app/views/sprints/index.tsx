import React from 'react';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { Card } from '../../javascript/components/card/card';
import { Button } from '../../javascript/components/button/button';
import { useModal } from '../../javascript/components/modal/modal';
import { useReaction } from '../../javascript/sprinkles/reaction';

export default function ({
  data: { currentUser, sprints, nextPageUrl },
}: PageProps<'sprints/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="headline">{t('users.index.title')}</Text>
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
              <table className="table">
                <thead>
                  <tr>
                    <th></th>
                    <th>Daily Nerd</th>
                    <th>Tracked</th>
                    <th>Billable</th>
                    <th>Retro</th>
                    <th>Storypoints</th>
                    <th>Turnover</th>
                  </tr>
                </thead>
                <tbody>
                  {sprint.performances.map((performance) => (
                    <tr key={performance.id}>
                      <td>
                        {performance.user.displayName}
                        <br />
                        {performance.workingDayCount}/{performance.holidayCount}
                        /{performance.sickDayCount}
                      </td>
                      <td>{performance.dailyNerdCount}</td>
                      <td>
                        {l.singleDigitNumber(performance.trackedHours)}
                        <br />
                        {l.singleDigitNumber(
                          performance.trackedHours / performance.workingDayCount
                        )}
                        /day
                      </td>
                      <td>
                        {l.singleDigitNumber(performance.billableHours)}
                        <br />
                        {l.singleDigitNumber(
                          performance.billableHours /
                            performance.workingDayCount
                        )}
                        /day
                      </td>
                      <td>{performance.retroRating}</td>
                      <td>
                        {performance.finishedStorypoints}
                        <br />
                        {l.singleDigitNumber(
                          performance.finishedStorypoints /
                            performance.workingDayCount
                        )}
                        /day
                      </td>
                      <td>{l.currency(performance.revenue)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
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
