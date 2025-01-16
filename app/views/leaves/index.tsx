import React from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { Card } from '../../frontend/components/card/card';
import { Button } from '../../frontend/components/button/button';
import { useModal } from '../../frontend/components/modal/modal';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Link } from '../../frontend/sprinkles/history';
import { Pill } from '../../frontend/components/pill/pill';

export default function ({
  data: { nextPageUrl, currentUser, leaves, activeFilter, feedUrl },
}: PageProps<'leaves/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="headline">{t('leaves.index.title')}</Text>
          <a href={feedUrl}>{t('leaves.index.subscribe')}</a>
          <Button
            title={t('leaves.index.request')}
            onClick={() => modal.present('/leaves/new')}
          />
        </Stack>
        <Stack line="mobile">
          {['all', 'pending_approval', 'rejected'].map((e) => (
            <Link key={e} href={`/leaves?status=${e}`}>
              <Pill active={e === activeFilter}>{e}</Pill>
            </Link>
          ))}
        </Stack>
        <Stack>
          {leaves.map((leave) => (
            <Card
              id={`leave_${leave.id}`}
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
                  {!!leave.permitApprove && (
                    <>
                      <Button
                        title="👍"
                        onClick={() =>
                          reaction.call({
                            path: `/leaves/${leave.id}`,
                            method: 'PATCH',
                            params: { leave: { status: 'approved' } },
                            refresh: true,
                          })
                        }
                      />
                      <Button
                        title="👎"
                        onClick={() =>
                          reaction.call({
                            path: `/leaves/${leave.id}`,
                            method: 'PATCH',
                            params: { leave: { status: 'rejected' } },
                            refresh: true,
                          })
                        }
                      />
                    </>
                  )}
                  {leave.permitDestroy && (
                    <Button
                      title="🗑️"
                      onClick={() =>
                        reaction.call({
                          path: `/leaves/${leave.id}`,
                          method: 'DELETE',
                          refresh: true,
                        })
                      }
                    />
                  )}
                </>
              }
            />
          ))}
          {nextPageUrl && (
            <Button
              title={t('leaves.index.more')}
              onClick={() =>
                reaction.history.extendPageContentWithPagination(
                  nextPageUrl,
                  'leaves'
                )
              }
            />
          )}
        </Stack>
      </Stack>
    </Layout>
  );
}
