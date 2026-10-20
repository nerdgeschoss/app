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
import { SelectField } from '../../frontend/components/select_field/select_field';
import { useModal } from '../../frontend/components/modal/modal';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Link } from '../../frontend/sprinkles/history';
import { Pill } from '../../frontend/components/pill/pill';
import { LeaveCard } from './_leave_card';

export default function ({
  data: {
    currentUser,
    user,
    feedUrl,
    activeFilter,
    permitHrOverview,
    permitCreate,
    years,
    year,
    month,
    leaves,
    dayCounts,
    nextPageUrl,
    yearlyHolidays,
    remainingHolidays,
  },
}: PageProps<'leaves/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();

  const currentYear = new Date().getFullYear();
  const selectedYear = year ?? currentYear;

  const translations = {
    all: t('leaves.types.all'),
    pending_approval: t('leaves.types.pending_approval'),
    approved: t('leaves.types.approved'),
    rejected: t('leaves.types.rejected'),
  } as const;

  const leavesPath = (filter: {
    status?: string;
    year?: number | null;
    month?: number | null;
  }): string => {
    const params = new URLSearchParams();
    if (filter.status && filter.status !== 'all') {
      params.set('status', filter.status);
    }
    params.set('year', String(filter.year ?? selectedYear));
    if (typeof filter.month === 'number') {
      params.set('month', String(filter.month));
    }
    return `/users/${user.id}/leaves?${params}`;
  };

  const dayCount = (n: number): string =>
    n === 1
      ? t('leaves.index.one_day')
      : t('leaves.index.days', { amount: String(n) });

  const monthOptions = [
    { value: '', label: t('leaves.index.all_months') },
    ...Array.from({ length: 12 }, (_, index) => ({
      value: String(index + 1),
      label: l.monthName(new Date(2000, index, 1)) ?? '',
    })),
  ];

  // the current year is always offered, even before it has any leaves
  const yearOptions = Array.from(new Set([...years, currentYear]))
    .sort((a, b) => b - a)
    .map((value) => ({ value: String(value), label: String(value) }));

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="tablet" justify="space-between" alignTablet="center">
          <Stack line="mobile" size={16} align="center" fullWidth="none">
            {user.id !== currentUser.id && (
              <Avatar
                displayName={user.displayName}
                avatarUrl={user.avatarUrl}
                email={user.email}
              />
            )}
            <Text type="h1-bold">
              {user.id !== currentUser.id
                ? t('leaves.index.title_of', { name: user.displayName })
                : t('leaves.index.title')}
            </Text>
          </Stack>
          <Stack line="mobile" size={16} align="center" fullWidth="none" wrap>
            <a href={feedUrl}>{t('leaves.index.subscribe')}</a>
            {permitCreate && (
              <Button
                title={t('leaves.index.request')}
                onClick={() => modal.present(`/users/${user.id}/leaves/new`)}
              />
            )}
            {permitHrOverview && (
              <Button
                variant="secondary"
                title={t('leaves.index.overview')}
                onClick={() => reaction.history.navigate('/leaves/hr_overview')}
              />
            )}
          </Stack>
        </Stack>
        <Stack line="tablet" justify="space-between" alignTablet="center">
          <Stack line="mobile" size={4} fullWidth="none" wrap>
            {Object.entries(translations).map(([key, label]) => (
              <Link
                key={key}
                href={leavesPath({ status: key, year: selectedYear, month })}
              >
                <Pill active={key === activeFilter}>{label}</Pill>
              </Link>
            ))}
          </Stack>
          <Stack line="mobile" size={12} fullWidth="none">
            <SelectField
              value={month ? String(month) : ''}
              options={monthOptions}
              ariaLabel={t('leaves.index.all_months')}
              onChange={(value) =>
                reaction.history.navigate(
                  leavesPath({
                    status: activeFilter,
                    year: selectedYear,
                    month: value ? Number(value) : null,
                  })
                )
              }
            />
            <SelectField
              value={String(selectedYear)}
              options={yearOptions}
              onChange={(value) =>
                reaction.history.navigate(
                  leavesPath({
                    status: activeFilter,
                    year: Number(value),
                    month,
                  })
                )
              }
            />
          </Stack>
        </Stack>
        {activeFilter === 'all' && (
          <Grid minColumnWidth={320} gap={20}>
            <Card>
              <Stack size={8}>
                <Stack line="mobile" justify="space-between">
                  <Text type="body-bold">{`🏖 ${t('leaves.leave_types.paid')}`}</Text>
                  <Text type="body-bold">{dayCount(dayCounts.paid)}</Text>
                </Stack>
                {selectedYear === currentYear && (
                  <Stack line="mobile" justify="space-between">
                    <Text>
                      {t('leaves.index.remaining_for', {
                        year: String(selectedYear),
                      })}
                    </Text>
                    <Text>
                      {t('leaves.index.remaining_days', {
                        remaining: String(remainingHolidays),
                        total: String(yearlyHolidays),
                      })}
                    </Text>
                  </Stack>
                )}
              </Stack>
            </Card>
            <Card>
              <Stack size={8}>
                <Stack line="mobile" justify="space-between">
                  <Text type="body-bold">{`🤒 ${t('leaves.leave_types.sick')}`}</Text>
                  <Text type="body-bold">{dayCount(dayCounts.sick)}</Text>
                </Stack>
                <Stack line="mobile" justify="space-between">
                  <Text type="body-bold">{`🧳 ${t('leaves.leave_types.non_working')}`}</Text>
                  <Text type="body-bold">{dayCount(dayCounts.nonWorking)}</Text>
                </Stack>
              </Stack>
            </Card>
          </Grid>
        )}
        <Grid
          gap={20}
          columns="repeat(auto-fill, minmax(clamp(200px, 320px, 100%), 1fr))"
        >
          {leaves.map((leave) => (
            <LeaveCard key={leave.id} leave={leave} showStatus />
          ))}
        </Grid>
        {nextPageUrl && (
          <Button
            title={t('leaves.index.more')}
            onClick={() =>
              reaction.history.extendPageContentWithPagination(
                nextPageUrl,
                'leaves'
              )
            }
          />
        )}
      </Stack>
    </Layout>
  );
}
