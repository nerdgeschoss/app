import React from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Card } from '../../frontend/components/card/card';
import { Text } from '../../frontend/components/text/text';
import { useModal } from '../../frontend/components/modal/modal';
import { Button } from '../../frontend/components/button/button';

export default function ({
  data: { currentUser, feedback },
}: PageProps<'sprint_feedbacks/show'>): JSX.Element {
  const l = useFormatter();
  const hourGoal = feedback.workingDayCount * 7.5;
  const modal = useModal();

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="h1-bold">{feedback.sprint.title}</Text>
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
                <Text multiline>{feedback.retroText}</Text>
                {feedback.permitEditRetroNotes && (
                  <Button
                    title={
                      feedback.retroText ? 'edit feedback' : 'leave feedback'
                    }
                    onClick={() =>
                      modal.present(
                        `/en/sprint_feedbacks/${feedback.id}/edit_retro`
                      )
                    }
                  />
                )}
              </Stack>
            </Stack>
            {feedback.days.map((day) => (
              <Card
                key={day.id}
                title={l.dayName(day.day)}
                subtitle={l.date(day.day)}
              >
                <Stack>
                  {day.timeEntries.length > 0 && (
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
                  )}
                  {day.dailyNerdMessage && (
                    <Text multiline>{day.dailyNerdMessage.message}</Text>
                  )}
                </Stack>
              </Card>
            ))}
          </Stack>
        </Card>
      </Stack>
    </Layout>
  );
}
