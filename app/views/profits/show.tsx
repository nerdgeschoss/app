import React from 'react';
import { PageProps } from '../../../data.d';
import { Layout } from '../../frontend/components/layout/layout';
import { Pill } from '../../frontend/components/pill/pill';
import { Stack } from '../../frontend/components/stack/stack';
import { Table } from '../../frontend/components/table/table';
import { Text } from '../../frontend/components/text/text';
import { Tooltip } from '../../frontend/components/tooltip/tooltip';
import { Link } from '../../frontend/sprinkles/history';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';

export default function Profit({
  data: { currentUser, year, years, months },
}: PageProps<'profits/show'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();

  function running(value: number): JSX.Element {
    return (
      <Text
        type="caption-secondary-regular"
        color={value < 0 ? 'text-warning' : 'label-body-secondary'}
      >
        {l.currency(value)}
      </Text>
    );
  }

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="h1-bold">{t('profit.show.title')}</Text>
        <Stack line="mobile" size={4}>
          {years.map((y) => (
            <Link key={y} href={`/profit?year=${y}`}>
              <Pill active={y === year}>{y.toString()}</Pill>
            </Link>
          ))}
        </Stack>
        <Table>
          <thead>
            <tr>
              <th>{t('profit.show.columns.month')}</th>
              <th>{t('profit.show.columns.user')}</th>
              <th>{t('profit.show.columns.cost')}</th>
              <th>{t('profit.show.columns.revenue')}</th>
              <th>{t('profit.show.columns.profit')}</th>
            </tr>
          </thead>
          {months.map((month) => {
            const span = Math.max(month.rows.length, 1) + 1;
            const monthLabel = l.monthAndYear(month.date);
            return (
              <tbody key={month.date}>
                {month.rows.length === 0 ? (
                  <tr>
                    <td rowSpan={span}>{monthLabel}</td>
                    <td colSpan={4}>{t('profit.show.no_data')}</td>
                  </tr>
                ) : (
                  month.rows.map((row, index) => (
                    <tr key={row.user.id}>
                      {index === 0 && <td rowSpan={span}>{monthLabel}</td>}
                      <td>{row.user.displayName}</td>
                      <td>
                        <Tooltip
                          content={
                            <>
                              <div>
                                {t('profit.show.cost_breakdown.salary')}:{' '}
                                {l.currency(row.salary)}
                              </div>
                              <div>
                                {t('profit.show.cost_breakdown.payroll_taxes')}:{' '}
                                {l.currency(row.payrollTaxes)}
                              </div>
                              <div>
                                {t('profit.show.cost_breakdown.benefits')}:{' '}
                                {l.currency(row.benefits)}
                              </div>
                              <div>
                                {t('profit.show.cost_breakdown.fixed_share')}:{' '}
                                {l.currency(row.fixedShare)}
                              </div>
                            </>
                          }
                        >
                          <span>{l.currency(row.cost)}</span>
                        </Tooltip>
                        {running(row.runningCost)}
                      </td>
                      <td>
                        {row.revenueByProject.length > 0 ? (
                          <Tooltip
                            content={
                              <>
                                {row.revenueByProject.map((p) => (
                                  <div key={p.project}>
                                    {p.project}: {l.hours(p.hours)}h –{' '}
                                    {l.currency(p.revenue)}
                                  </div>
                                ))}
                              </>
                            }
                          >
                            <span>{l.currency(row.revenue)}</span>
                          </Tooltip>
                        ) : (
                          l.currency(row.revenue)
                        )}
                        {running(row.runningRevenue)}
                      </td>
                      <td>
                        <Text
                          color={row.profit < 0 ? 'text-warning' : undefined}
                        >
                          {l.currency(row.profit)}
                        </Text>
                        {running(row.runningProfit)}
                      </td>
                    </tr>
                  ))
                )}
                <tr>
                  <td>
                    <Text type="body-bold">{t('profit.show.total')}</Text>
                  </td>
                  <td>
                    <Text type="body-bold">{l.currency(month.totalCost)}</Text>
                    {running(month.totalRunningCost)}
                  </td>
                  <td>
                    <Text type="body-bold">
                      {l.currency(month.totalRevenue)}
                    </Text>
                    {running(month.totalRunningRevenue)}
                  </td>
                  <td>
                    <Text
                      type="body-bold"
                      color={month.totalProfit < 0 ? 'text-warning' : undefined}
                    >
                      {l.currency(month.totalProfit)}
                    </Text>
                    {running(month.totalRunningProfit)}
                  </td>
                </tr>
              </tbody>
            );
          })}
        </Table>
      </Stack>
    </Layout>
  );
}
