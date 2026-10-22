import { JSX } from 'react';
import { PageProps } from '../../../data';
import { useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { Card } from '../../frontend/components/card/card';
import { Button } from '../../frontend/components/button/button';
import { Grid } from '../../frontend/components/grid/grid';
import { Pill } from '../../frontend/components/pill/pill';
import { Link } from '../../frontend/sprinkles/history';
import { useModal } from '../../frontend/components/modal/modal';
import {
  LeaveCalendar,
  LeaveCalendarRow,
} from '../../frontend/components/leave_calendar/leave_calendar';
import { LeaveCard } from '../leaves/_leave_card';

export default function ({
  data: {
    currentUser,
    date,
    feedUrl,
    pendingLeaves,
    pendingLeavesCounts,
    pendingLeaveType,
    users,
    leaves,
  },
}: PageProps<'leaves_overviews/show'>): JSX.Element {
  const t = useTranslate();
  const modal = useModal();

  // `date` is an ISO day, not always the first of the month; new Date(date)
  // would be UTC midnight and shift the month for viewers west of UTC
  const [year, month] = date.split('-').map(Number);

  const overviewPath = ({
    year,
    month,
    pendingLeaveType,
  }: {
    year: number;
    month: number;
    pendingLeaveType: string;
  }): string => {
    const params = new URLSearchParams();
    params.set('year', String(year));
    params.set('month', String(month));
    // paid is the controller's default, so its URLs stay without the type
    if (pendingLeaveType !== 'paid') {
      params.set('pending_leave_type', pendingLeaveType);
    }
    return `/leaves_overview?${params}`;
  };

  // switching months keeps the selected pending type
  const monthUrl = (delta: -1 | 1): string => {
    const target = new Date(year, month - 1 + delta, 1);
    return overviewPath({
      year: target.getFullYear(),
      month: target.getMonth() + 1,
      pendingLeaveType,
    });
  };

  const pendingTypes = [
    {
      type: 'paid',
      label: t('leaves.hr_overview.pending_paid', {
        amount: String(pendingLeavesCounts.paid),
      }),
    },
    {
      type: 'sick',
      label: t('leaves.hr_overview.pending_sick', {
        amount: String(pendingLeavesCounts.sick),
      }),
    },
    {
      type: 'non_working',
      label: t('leaves.hr_overview.pending_non_working', {
        amount: String(pendingLeavesCounts.nonWorking),
      }),
    },
  ];

  const rowUrl = (userId: string): string =>
    `/users/${userId}/leaves?year=${year}&month=${month}`;

  const rows: LeaveCalendarRow[] = users.map((user) => ({
    user,
    dayCounts: user.dayCounts,
    leaves: leaves
      .filter((leave) => leave.userId === user.id)
      .map((leave) => ({
        id: leave.id,
        type: leave.type,
        status: leave.status,
        unicodeEmoji: leave.unicodeEmoji,
        days: leave.days.map((day) => day.day),
      })),
  }));

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

        <Stack line="mobile" size={4} fullWidth="none" wrap>
          {pendingTypes.map(({ type, label }) => (
            <Link
              key={type}
              href={overviewPath({ year, month, pendingLeaveType: type })}
            >
              <Pill active={type === pendingLeaveType}>{label}</Pill>
            </Link>
          ))}
        </Stack>

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
          <LeaveCalendar
            year={year}
            month={month}
            rows={rows}
            previousMonthUrl={monthUrl(-1)}
            nextMonthUrl={monthUrl(1)}
            rowUrl={rowUrl}
          />
        </Card>
      </Stack>
    </Layout>
  );
}
