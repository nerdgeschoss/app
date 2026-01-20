import React from 'react';
import { PageProps } from '../../../data.d';
import { Card } from '../../frontend/components/card/card';
import { Columns } from '../../frontend/components/columns/columns';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { Link } from '../../frontend/sprinkles/history';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { DailyNerdCard } from './_daily_nerd_card';

export default function Home({
  data: {
    currentUser,
    upcomingLeaves,
    payslips,
    remainingHolidays,
    dailyNerdMessage,
    needsRetroFor,
  },
}: PageProps<'pages/home'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="h1-bold">
          {t('pages.home.hello', { name: currentUser.displayName })}
        </Text>
        <Columns>
          {needsRetroFor && (
            <Card
              icon="🚀"
              title={t('pages.home.missing_retro')}
              subtitle={
                <Stack>
                  {t('pages.home.missing_retro_description', {
                    title: needsRetroFor.title,
                  })}
                  <Link href={`/en/sprint_feedbacks/${needsRetroFor.id}`}>
                    {t('pages.home.leave_retro_notes')}
                  </Link>
                </Stack>
              }
            />
          )}
          {dailyNerdMessage && <DailyNerdCard {...dailyNerdMessage} />}
          {upcomingLeaves.length > 0 && (
            <Card
              icon="🏝️"
              title={t('pages.home.upcoming_holidays')}
              subtitle={upcomingLeaves.map((leave) => (
                <div key={leave.id}>
                  {l.dateRange(leave.startDate, leave.endDate)} (
                  {leave.days.length + ' day'}
                  {leave.days.length !== 1 ? 's' : ''}): {leave.title}
                </div>
              ))}
            />
          )}
          {payslips.length > 0 && (
            <Card
              icon="💸"
              title={t('pages.home.last_payments')}
              subtitle={
                <Stack size={2}>
                  {payslips.map((payslip) => (
                    <a key={payslip.id} href={payslip.url} target="_blank">
                      {l.monthAndYear(payslip.month)}
                    </a>
                  ))}
                </Stack>
              }
              context={
                <Link href="/payslips">{t('pages.home.payslip_archive')}</Link>
              }
            />
          )}
          <Card
            icon="⏰"
            title={t('pages.home.remaining_holidays')}
            subtitle={t('pages.home.number_holidays_left', {
              count: remainingHolidays,
            })}
          />
        </Columns>
      </Stack>
    </Layout>
  );
}
