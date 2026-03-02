import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { EmployeeCard } from '../../frontend/components/employee_card/employee_card';
import { Button } from '../../frontend/components/button/button';
import { downloadFile } from '../../frontend/util/download';

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
            {feedback.permitDownloadJson && (
              <Button
                title={t('sprint_feedbacks.download_json')}
                onClick={() =>
                  downloadFile(
                    new Blob([JSON.stringify(feedback, null, 2)], {
                      type: 'application/json',
                    }),
                    `sprint-feedback-${feedback.sprint.title}-${feedback.user.displayName}.json`
                  )
                }
              />
            )}
          </Stack>
          <EmployeeCard {...feedback} />
        </Stack>
      </Stack>
    </Layout>
  );
}
