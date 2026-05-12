import React from 'react';
import { PageProps } from '../../../data.d';
import { Layout } from '../../frontend/components/layout/layout';
import { Pill } from '../../frontend/components/pill/pill';
import { Stack } from '../../frontend/components/stack/stack';
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
        <table className="profit__table">
          <thead>
            <tr>
              <th>{t('profit.show.columns.month')}</th>
              <th>{t('profit.show.columns.user')}</th>
              <th>{t('profit.show.columns.cost')}</th>
              <th>{t('profit.show.columns.revenue')}</th>
              <th>{t('profit.show.columns.profit')}</th>
            </tr>
          </thead>
          <tbody>
            {months.map((month) => {
              const span = Math.max(month.rows.length, 1) + 1;
              const monthLabel = l.monthAndYear(month.date);
              return (
                <React.Fragment key={month.date}>
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
                        <td>{l.currency(row.cost)}</td>
                        <td>{l.currency(row.revenue)}</td>
                        <td>{l.currency(row.profit)}</td>
                      </tr>
                    ))
                  )}
                  <tr>
                    <td>{t('profit.show.total')}</td>
                    <td>{l.currency(month.totalCost)}</td>
                    <td>{l.currency(month.totalRevenue)}</td>
                    <td>{l.currency(month.totalProfit)}</td>
                  </tr>
                </React.Fragment>
              );
            })}
          </tbody>
        </table>
      </Stack>
    </Layout>
  );
}
