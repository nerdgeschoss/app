import React from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { Card } from '../../javascript/components/card/card';
import { Pill } from '../../javascript/components/pill/pill';
import { Link } from '../../javascript/sprinkles/history';

export default function ({
  data: { filter, users, currentUser },
}: PageProps<'users/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="headline">{t('users.index.title')}</Text>
        <Stack line="mobile">
          {['employee', 'sprinter', 'hr', 'archive'].map((e) => (
            <Link key={e} href={`/users?filter=${e}`}>
              <Pill active={e === filter}>{e}</Pill>
            </Link>
          ))}
        </Stack>
        {users.map((user) => (
          <Card
            key={user.id}
            href={`/users/${user.id}`}
            icon={<img src={user.avatarUrl} alt="" />}
            title={
              <>
                {user.fullName} {user.nickName && `(${user.nickName})`}
              </>
            }
            subtitle={
              <>
                {t('users.index.number_holidays_left', {
                  count: user.remainingHolidays,
                })}
                {user.currentSalary && (
                  <div>
                    {t('users.index.salary_since', {
                      amount: l.currency(user.currentSalary.brut),
                      date: l.date(user.currentSalary.validFrom),
                    })}
                  </div>
                )}
              </>
            }
          />
        ))}
      </Stack>
    </Layout>
  );
}
