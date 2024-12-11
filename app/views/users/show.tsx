import React from 'react';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { Card } from '../../javascript/components/card/card';
import { useModal } from '../../javascript/components/modal/modal';
import { PageProps } from '../../../data.d';

export default function ({
  data: { currentUser, user, salaries, inventories, permitEditInventory },
}: PageProps<'users/show'>): JSX.Element {
  const modal = useModal();
  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="headline">{user.fullName}</Text>
        <Card
          title="remaining holidays"
          subtitle={user.remainingHolidays}
          icon="⏰"
        />
        <Card title="salary history" icon="💰">
          <Stack>
            {salaries.map((salary) => (
              <a
                key={salary.id}
                href={
                  salary.hgfHash
                    ? `"https://nerdgeschoss.de/handbook/hgf/#${salary.hgf_hash}`
                    : undefined
                }
              >
                <div>{salary.validFrom}</div>
                <div>{salary.brut}</div>
              </a>
            ))}
          </Stack>
        </Card>
        <Card
          title="Inventory"
          icon="💻"
          context={
            permitEditInventory && (
              <button
                onClick={(event) => {
                  event.preventDefault();
                  modal.present(`/users/${user.id}/inventories/new`);
                }}
              >
                add
              </button>
            )
          }
        >
          <Stack>
            {inventories.map((inventory) => (
              <Stack key={inventory.id} size={4}>
                <Text>{inventory.name}</Text>
                <Text>{inventory.details}</Text>
              </Stack>
            ))}
          </Stack>
        </Card>
      </Stack>
    </Layout>
  );
}
