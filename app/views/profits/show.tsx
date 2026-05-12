import React from 'react';
import { PageProps } from '../../../data.d';
import { Layout } from '../../frontend/components/layout/layout';
import { Pill } from '../../frontend/components/pill/pill';
import { Stack } from '../../frontend/components/stack/stack';
import { Table } from '../../frontend/components/table/table';
import { Text } from '../../frontend/components/text/text';
import { Link } from '../../frontend/sprinkles/history';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';

export default function Profit({
  data: { currentUser, year, years, months },
}: PageProps<'profits/show'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();

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
              <th>{t('profit.show.columns.running')}</th>
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
                    <td colSpan={5}>{t('profit.show.no_data')}</td>
                  </tr>
                ) : (
                  month.rows.map((row, index) => (
                    <tr key={row.user.id}>
                      {index === 0 && <td rowSpan={span}>{monthLabel}</td>}
                      <td>{row.user.displayName}</td>
                      <td>{l.currency(row.cost)}</td>
                      <td>{l.currency(row.revenue)}</td>
                      <td>
                        <Text
                          color={row.profit < 0 ? 'text-warning' : undefined}
                        >
                          {l.currency(row.profit)}
                        </Text>
                      </td>
                      <td>
                        <Text
                          color={row.running < 0 ? 'text-warning' : undefined}
                        >
                          {l.currency(row.running)}
                        </Text>
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
                  </td>
                  <td>
                    <Text type="body-bold">
                      {l.currency(month.totalRevenue)}
                    </Text>
                  </td>
                  <td>
                    <Text
                      type="body-bold"
                      color={month.totalProfit < 0 ? 'text-warning' : undefined}
                    >
                      {l.currency(month.totalProfit)}
                    </Text>
                  </td>
                  <td>
                    <Text
                      type="body-bold"
                      color={
                        month.totalRunning < 0 ? 'text-warning' : undefined
                      }
                    >
                      {l.currency(month.totalRunning)}
                    </Text>
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
