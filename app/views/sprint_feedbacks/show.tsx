import { PageProps } from '../../../data.d';
import { useFormatter } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { EmployeeCard } from '../../frontend/components/employee_card/employee_card';

export default function ({
  data: { currentUser, feedback },
}: PageProps<'sprint_feedbacks/show'>): JSX.Element {
  const l = useFormatter();

  const sprintTitle = feedback.sprint.title
    .replace('Sprint ', '🏃🏻 ')
    .split('-')
    .join(' -  ');

  const startDate = new Date(feedback.sprint.sprintFrom);
  const endDate = new Date(feedback.sprint.sprintUntil);

  return (
    <Layout user={currentUser} container>
      <Stack size={16} tabletSize={32}>
        <Text type="h2-bold" color="label-heading-primary">
          Sprints
        </Text>
        <Stack>
          <Stack line="mobile" align="center" size={8}>
            <Text type="h3-bold">{sprintTitle}</Text>
            <Text type="h4-regular" color="label-heading-secondary">
              {l.dateRange(startDate, endDate, {
                month: 'long',
                day: 'numeric',
                year: 'numeric',
              })}
            </Text>
          </Stack>
          <EmployeeCard {...feedback} />
        </Stack>
      </Stack>
    </Layout>
  );
}
