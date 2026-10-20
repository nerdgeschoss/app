import { JSX } from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { Card } from '../../frontend/components/card/card';
import { Button } from '../../frontend/components/button/button';
import { Avatar } from '../../frontend/components/avatar/avatar';
import { Grid } from '../../frontend/components/grid/grid';
import { useModal } from '../../frontend/components/modal/modal';
import { Link } from '../../frontend/sprinkles/history';
import { LeaveCard } from './_leave_card';

export default function ({
  data: { currentUser, date, feedUrl, pendingLeaves, users },
}: PageProps<'leaves/hr_overview'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const modal = useModal();

  const month = new Date(date);

  const monthUrl = (delta: -1 | 1): string => {
    const target = new Date(month.getFullYear(), month.getMonth() + delta, 1);
    return `/leaves/hr_overview?year=${target.getFullYear()}&month=${target.getMonth() + 1}`;
  };

  const rowUrl = (userId: string): string =>
    `/users/${userId}/leaves?year=${month.getFullYear()}&month=${month.getMonth() + 1}`;

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="tablet" justify="space-between" alignTablet="center">
          <Text type="h1-bold">{t('leaves.hr_overview.title')}</Text>
          <Stack line="mobile" size={16} align="center" fullWidth="none" wrap>
            <a href={feedUrl}>{t('leaves.index.subscribe')}</a>
            <Button
              title={t('leaves.index.request')}
              onClick={() =>
                modal.present(`/users/${currentUser.id}/leaves/new`)
              }
            />
            <Button title={t('leaves.index.overview')} disabled />
          </Stack>
        </Stack>
        <Text type="h3-bold">{`⏳ ${t('leaves.hr_overview.pending_requests')}`}</Text>
        <div id="pending_requests">
          {pendingLeaves.length > 0 ? (
            <Grid
              gap={20}
              columns="repeat(auto-fill, minmax(clamp(200px, 320px, 100%), 1fr))"
            >
              {pendingLeaves.map((leave) => (
                <LeaveCard key={leave.id} leave={leave} showUser />
              ))}
            </Grid>
          ) : (
            <Text>{t('leaves.hr_overview.no_pending')}</Text>
          )}
        </div>
        <Text type="h3-bold">{`📅 ${t('leaves.hr_overview.monthly_overview')}`}</Text>
        <Card>
          <Stack>
            <Stack line="mobile" size={16} align="center" fullWidth="none">
              <Link href={monthUrl(-1)}>‹</Link>
              <Text type="h3-bold">{l.monthAndYear(month)}</Text>
              <Link href={monthUrl(1)}>›</Link>
            </Stack>
            {users.map((user) => (
              <Link key={user.id} href={rowUrl(user.id)}>
                <Stack line="mobile" size={12} align="center">
                  <Avatar
                    displayName={user.displayName}
                    avatarUrl={user.avatarUrl}
                    email={user.email}
                  />
                  <Stack size={4} fullWidth="none">
                    <Text>{user.displayName}</Text>
                    <Text type="body-bold">{`🏖 ${user.dayCounts.paid}  🤒 ${user.dayCounts.sick}  🧳 ${user.dayCounts.nonWorking}`}</Text>
                  </Stack>
                </Stack>
              </Link>
            ))}
          </Stack>
        </Card>
      </Stack>
    </Layout>
  );
}
