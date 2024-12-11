import React from 'react';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { Card } from '../../javascript/components/card/card';

export default function ({
  data: { filters, users, currentUser, leaves, activeFilter },
}: PageProps<'leaves/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="headline">{t('users.index.title')}</Text>
        <Stack line="mobile">
          {filters.map((e) => (
            <a
              key={e.id}
              className={`pill ${e.id === activeFilter ? 'active' : ''}`}
              href={`/leaves?status=${e}`}
            >
              {e.id}
            </a>
          ))}
          <pre>{JSON.stringify(leaves, null, 2)}</pre>
        </Stack>
      </Stack>
    </Layout>
  );
}
