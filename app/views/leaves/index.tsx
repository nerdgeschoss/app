import React from 'react';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { Card } from '../../javascript/components/card/card';
import { Button } from '../../javascript/components/button/button';
import { useReaction } from '../../javascript/sprinkles/reaction';

export default function ({
  data: { users, currentUser, leaves, activeFilter },
}: PageProps<'leaves/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="headline">{t('users.index.title')}</Text>
        <Stack line="mobile">
          {['all', 'pending_approval', 'rejected'].map((e) => (
            <a
              key={e}
              className={`pill ${e === activeFilter ? 'active' : ''}`}
              href={`/leaves?status=${e}`}
            >
              {e}
            </a>
          ))}
        </Stack>
        <Stack>
          {leaves.map((leave) => (
            <Card
              key={leave.id}
              icon={leave.unicodeEmoji}
              title={[leave.user.displayName, leave.title].join(' / ')}
              subtitle={
                <>
                  <Text>
                    {l.dateRange(
                      leave.days[0]?.day,
                      leave.days[leave.days.length - 1]?.day
                    )}
                  </Text>
                  <Text>{leave.status}</Text>
                </>
              }
              context={
                <>
                  {leave.permitDestroy && (
                    <Button
                      title="delete"
                      onClick={() =>
                        reaction.call({
                          path: `/leaves/${leave.id}`,
                          method: 'DELETE',
                        })
                      }
                    />
                  )}
                </>
              }
            />
          ))}
        </Stack>
        <pre>{JSON.stringify(leaves, null, 2)}</pre>
      </Stack>
    </Layout>
  );
}
