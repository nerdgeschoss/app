import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { EmployeeCard } from '../../frontend/components/employee_card/employee_card';
import { JSX } from 'react';

export default function ({
  data: { currentUser, feedback },
}: PageProps<'sprint_feedbacks/show'>): JSX.Element {
  const l = useFormatter();
  const t = useTranslate();

  return (
    <Layout user={currentUser} container>
      <Stack size={16} tabletSize={32}>
        <Text type="h2-bold" color="label-heading-primary">
          {t('sprint_feedbacks.sprints')}
        </Text>
        <Stack>
          <Stack line="mobile" align="center" size={8}>
            <Text type="h3-bold">🏃🏻 {feedback.sprint.title}</Text>
            <Text type="h4-regular" color="label-heading-secondary">
              {l.dateRangeLong(
                feedback.sprint.sprintFrom,
                feedback.sprint.sprintUntil
              )}
            </Text>
          </Stack>
          <EmployeeCard {...feedback} />
        </Stack>
        <Stack size={8}>
          <Text type="h3-bold">Time Distribution</Text>
          <ul>
            {feedback.timeDistribution.clients.map((client) => (
              <li key={client.id}>
                {client.name} — {l.percentage(client.percentage)} (
                {l.hours(client.hours)}h)
                <ul>
                  {client.projects.map((project) => (
                    <li key={project.id}>
                      {project.name}
                      <ul>
                        {project.entries.map((entry) => (
                          <li key={entry.id}>
                            {entry.task
                              ? `${entry.task.title}${entry.task.issueNumber ? ` #${entry.task.issueNumber}` : ''}`
                              : '—'}{' '}
                            — {l.percentage(entry.percentage)} (
                            {l.hours(entry.hours)}h)
                          </li>
                        ))}
                      </ul>
                    </li>
                  ))}
                </ul>
              </li>
            ))}
          </ul>
        </Stack>
      </Stack>
    </Layout>
  );
}
