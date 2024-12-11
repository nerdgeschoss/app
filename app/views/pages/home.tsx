import React from 'react';
import { PageProps } from '../../../data.d';
import { Card } from '../../javascript/components/card/card';
import { Columns } from '../../javascript/components/columns/columns';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';

export default function Home({
  data: { currentUser, upcomingLeaves, payslips, remainingHolidays },
}: PageProps<'pages/home'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="headline">
          {t('pages.home.hello', { name: currentUser.displayName })}
        </Text>
        <Columns>
          {upcomingLeaves.length > 0 && (
            <Card
              icon="🏝️"
              title={t('pages.home.upcoming_holidays')}
              subtitle={upcomingLeaves.map((leave) => (
                <div key={leave.id}>
                  {l.dateRange(leave.startDate, leave.endDate)}: {leave.title}
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
                      {payslip.month}
                    </a>
                  ))}
                </Stack>
              }
            />
          )}
          <Card
            icon="⏰"
            title={t('pages.home.remaining_holidays')}
            subtitle={t('pages.home.number_holidays_left', {
              count: remainingHolidays,
            })}
            context={<a href="/payslips">{t('pages.home.payslip_archive')}</a>}
          />
        </Columns>
      </Stack>
    </Layout>
  );
}
