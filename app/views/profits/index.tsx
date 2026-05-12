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
}: PageProps<'profits/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();

  function running(value: number): JSX.Element {
    return (
      <Text
        type="caption-secondary-regular"
        color={value < 0 ? 'text-warning' : 'label-body-secondary'}
        align="right"
      >
        {l.currency(value)}
      </Text>
    );
  }

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="h1-bold">{t('profit.index.title')}</Text>
        <Stack line="mobile" size={4}>
          {years.map((y) => (
            <Link key={y} href={`/profits?year=${y}`}>
              <Pill active={y === year}>{y.toString()}</Pill>
            </Link>
          ))}
        </Stack>
        <Table>
          <thead>
            <tr>
              <th>{t('profit.index.columns.month')}</th>
              <th>{t('profit.index.columns.user')}</th>
              <th>
                <Text align="right">{t('profit.index.columns.cost')}</Text>
              </th>
              <th>
                <Text align="right">{t('profit.index.columns.revenue')}</Text>
              </th>
              <th>
                <Text align="right">{t('profit.index.columns.profit')}</Text>
              </th>
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
                    <td colSpan={4}>{t('profit.index.no_data')}</td>
                  </tr>
                ) : (
                  month.rows.map((row, index) => (
                    <tr key={row.user.id}>
                      {index === 0 && <td rowSpan={span}>{monthLabel}</td>}
                      <td>{row.user.displayName}</td>
                      <td>
                        <Text align="right">
                          <Tooltip
                            content={
                              <>
                                {row.salary !== 0 && (
                                  <div>
                                    {t('profit.index.cost_breakdown.salary')}:{' '}
                                    {l.currency(row.salary)}
                                  </div>
                                )}
                                {row.payrollTaxes !== 0 && (
                                  <div>
                                    {t(
                                      'profit.index.cost_breakdown.payroll_taxes'
                                    )}
                                    : {l.currency(row.payrollTaxes)}
                                  </div>
                                )}
                                {row.benefits !== 0 && (
                                  <div>
                                    {t('profit.index.cost_breakdown.benefits')}:{' '}
                                    {l.currency(row.benefits)}
                                  </div>
                                )}
                                {row.fixedShare !== 0 && (
                                  <div>
                                    {t(
                                      'profit.index.cost_breakdown.fixed_share'
                                    )}
                                    : {l.currency(row.fixedShare)}
                                  </div>
                                )}
                                {row.sickRefund !== 0 && (
                                  <div>
                                    {t(
                                      'profit.index.cost_breakdown.sick_refund'
                                    )}
                                    : {l.currency(-row.sickRefund)}
                                  </div>
                                )}
                              </>
                            }
                          >
                            <span>{l.currency(row.cost)}</span>
                          </Tooltip>
                        </Text>
                        {running(row.runningCost)}
                      </td>
                      <td>
                        {row.revenueByProject.length > 0 ? (
                          <Text align="right">
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
                          </Text>
                        ) : (
                          <Text align="right">{l.currency(row.revenue)}</Text>
                        )}
                        {running(row.runningRevenue)}
                      </td>
                      <td>
                        <Text
                          align="right"
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
                    <Text type="body-bold">{t('profit.index.total')}</Text>
                  </td>
                  <td>
                    <Text align="right">
                      <Tooltip
                        content={
                          <>
                            {month.totalSalary !== 0 && (
                              <div>
                                {t('profit.index.cost_breakdown.salary')}:{' '}
                                {l.currency(month.totalSalary)}
                              </div>
                            )}
                            {month.totalPayrollTaxes !== 0 && (
                              <div>
                                {t('profit.index.cost_breakdown.payroll_taxes')}
                                : {l.currency(month.totalPayrollTaxes)}
                              </div>
                            )}
                            {month.totalBenefits !== 0 && (
                              <div>
                                {t('profit.index.cost_breakdown.benefits')}:{' '}
                                {l.currency(month.totalBenefits)}
                              </div>
                            )}
                            {month.totalFixedShare !== 0 && (
                              <div>
                                {t('profit.index.cost_breakdown.fixed_share')}:{' '}
                                {l.currency(month.totalFixedShare)}
                              </div>
                            )}
                            {month.totalSickRefund !== 0 && (
                              <div>
                                {t('profit.index.cost_breakdown.sick_refund')}:{' '}
                                {l.currency(-month.totalSickRefund)}
                              </div>
                            )}
                          </>
                        }
                      >
                        <Text type="body-bold">
                          {l.currency(month.totalCost)}
                        </Text>
                      </Tooltip>
                    </Text>
                    {running(month.totalRunningCost)}
                  </td>
                  <td>
                    {month.revenueByProject.length > 0 ? (
                      <Text align="right">
                        <Tooltip
                          content={
                            <>
                              {month.revenueByProject.map((p) => (
                                <div key={p.project}>
                                  {p.project}: {l.hours(p.hours)}h –{' '}
                                  {l.currency(p.revenue)}
                                </div>
                              ))}
                            </>
                          }
                        >
                          <Text type="body-bold">
                            {l.currency(month.totalRevenue)}
                          </Text>
                        </Tooltip>
                      </Text>
                    ) : (
                      <Text type="body-bold" align="right">
                        {l.currency(month.totalRevenue)}
                      </Text>
                    )}
                    {running(month.totalRunningRevenue)}
                  </td>
                  <td>
                    <Text
                      type="body-bold"
                      align="right"
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
