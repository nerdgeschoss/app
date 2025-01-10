import React from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { Card } from '../../javascript/components/card/card';
import { Button } from '../../javascript/components/button/button';
import { useModal } from '../../javascript/components/modal/modal';
import { useReaction } from '../../javascript/sprinkles/reaction';
import { Link } from '../../javascript/sprinkles/history';
import { Pill } from '../../javascript/components/pill/pill';

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
