import React from 'react';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Card } from '../../javascript/components/card/card';
import { Text } from '../../javascript/components/text/text';
import { useModal } from '../../javascript/components/modal/modal';
import { useReaction } from '../../javascript/sprinkles/reaction';

export default function ({
  data: { currentUser, feedback },
}: PageProps<'sprint_feedbacks/show'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();
  const hourGoal = feedback.workingDayCount * 7.5;

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="headline">{feedback.sprint.title}</Text>
        </Stack>
        <Card>
          <Stack>
            <Stack line="tablet" justify="space-between" size={2}>
              <Text>
                {l.dateRange(
                  feedback.sprint.sprintFrom,
                  feedback.sprint.sprintUntil
                )}
              </Text>
              <Text>🔢 {feedback.finishedStorypoints}pts</Text>
              <Text>
                🔢 {l.singleDigitNumber(feedback.finishedStorypointsPerDay)}
                pts/day
              </Text>
              <Text>⭐️ {feedback.retroRating}/5</Text>
              <Text>💻 {feedback.workingDayCount} days</Text>
            </Stack>
            <Stack line="mobile" align="center" size={6}>
              <img src={feedback.user.avatarUrl} style={{ maxWidth: '40px' }} />
              <Text>{feedback.user.displayName}</Text>
            </Stack>
            <Stack line="desktop">
              <Stack size={0}>
                <Text>⏱ Sprint Overview</Text>
                <Text>{l.percentage(feedback.trackedHours / hourGoal)}</Text>
                <Text>
                  {l.singleDigitNumber(
                    feedback.trackedHours / feedback.workingDayCount
                  )}{' '}
                  hrs
                </Text>
                <Stack line="mobile">
                  <Text>
                    Missing:{' '}
                    {l.singleDigitNumber(hourGoal - feedback.trackedHours)} hrs
                  </Text>
                  <Text>Billable {feedback.billableHours} hrs</Text>
                </Stack>
                <Stack line="mobile">
                  <Text>Goal {l.singleDigitNumber(hourGoal)} hrs</Text>
                  <Text>Tracked {feedback.trackedHours} hrs</Text>
                </Stack>
              </Stack>
              <Stack size={0}>
                <Text>⏱ Daily Overview</Text>
              </Stack>
              <Stack size={0}>
                <Text>⭐ Retrospective</Text>
                <Text>{feedback.retroRating}/5</Text>
                <Text>
                  <pre>{feedback.retroText}</pre>
                </Text>
              </Stack>
            </Stack>
            {feedback.days.map((day) => (
              <Card
                key={day.id}
                title={l.dayName(day.day)}
                subtitle={l.date(day.day)}
              >
                <table className="table">
                  <thead>
                    <tr>
                      <td>Note</td>
                      <td>Task</td>
                      <td>Project</td>
                      <td>Tracked</td>
                      <td>Status</td>
                      <td>Members</td>
                      <td>Total Hours</td>
                    </tr>
                  </thead>
                  <tbody>
                    {day.timeEntries.map((timeEntry) => (
                      <tr key={timeEntry.id}>
                        <td>{timeEntry.notes}</td>
                        <td>{timeEntry.type}</td>
                        <td>{timeEntry.project?.name}</td>
                        <td>{timeEntry.hours}</td>
                        <td>{timeEntry.task?.status}</td>
                        <td></td>
                        <td>{timeEntry.task?.totalHours}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </Card>
            ))}
          </Stack>
        </Card>
      </Stack>
    </Layout>
  );
}
