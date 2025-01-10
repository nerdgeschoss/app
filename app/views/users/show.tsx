import React from 'react';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { Card } from '../../javascript/components/card/card';
import { Columns } from '../../javascript/components/columns/columns';
import { useModal } from '../../javascript/components/modal/modal';
import { useTranslate, useFormatter } from '../../javascript/util/dependencies';
import { PageProps } from '../../../data.d';

export default function ({
  data: { currentUser, user, salaries, inventories, permitEditInventory },
}: PageProps<'users/show'>): JSX.Element {
  const modal = useModal();
  const t = useTranslate();
  const l = useFormatter();
  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="headline">{user.fullName}</Text>
        <Columns>
          <Card
            title={t('users.show.remaining_holidays')}
            subtitle={user.remainingHolidays}
            icon="⏰"
          />
          <Card title={t('users.show.salary_history')} icon="💰">
            <Stack>
              {salaries.map((salary) => (
                <a
                  key={salary.id}
                  href={
                    salary.hgfHash
                      ? `https://nerdgeschoss.de/handbook/hgf/#${salary.hgfHash}`
                      : undefined
                  }
                  target="_blank"
                >
                  <div>{l.date(salary.validFrom)}</div>
                  <div>{l.currency(salary.brut)}</div>
                </a>
              ))}
            </Stack>
          </Card>
          <Card
            title={t('users.show.inventory')}
            icon="💻"
            context={
              permitEditInventory && (
                <button
                  onClick={(event) => {
                    event.preventDefault();
                    modal.present(`/users/${user.id}/inventories/new`);
                  }}
                >
                  {t('users.show.add_inventory')}
                </button>
              )
            }
          >
            <Stack>
              {inventories.map((inventory) => (
                <Stack size={4}>
                  <a
                    key={inventory.id}
                    onClick={(event) => {
                      event.preventDefault();
                      modal.present(`/inventories/${inventory.id}/edit`);
                    }}
                  >
                    {inventory.name}
                  </a>
                  <Text>{inventory.details}</Text>
                  <Text>
                    {inventory.returnedAt
                      ? l.dateRange(inventory.receivedAt, inventory.returnedAt)
                      : l.date(inventory.receivedAt)}
                  </Text>
                </Stack>
              ))}
            </Stack>
          </Card>
        </Columns>
      </Stack>
    </Layout>
  );
}
