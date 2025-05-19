import React from 'react';
import { PageProps } from '../../../data.d';
import { Card } from '../../frontend/components/card/card';
import { Columns } from '../../frontend/components/columns/columns';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { Button } from '../../frontend/components/button/button';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { useModal } from '../../frontend/components/modal/modal';

export default function Home({
  data: { currentUser, payslips, nextPageUrl },
}: PageProps<'payslips/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();
  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="h1-bold">
            {t('pages.home.hello', { name: currentUser.displayName })}
          </Text>
          <Button title="add" onClick={() => modal.present('/payslips/new')} />
        </Stack>
        <Columns>
          {payslips.map((payslip) => (
            <Card
              key={payslip.id}
              icon="💸"
              title={payslip.user.displayName}
              subtitle={l.monthAndYear(payslip.month)}
              context={
                <Stack line="mobile">
                  <a key={payslip.id} href={payslip.url} target="_blank">
                    ⬇️
                  </a>
                  {payslip.permitDestroy && (
                    <Button
                      title="delete"
                      onClick={() =>
                        reaction.call({
                          path: `/payslips/${payslip.id}`,
                          method: 'DELETE',
                          refresh: true,
                        })
                      }
                    />
                  )}
                </Stack>
              }
            />
          ))}
        </Columns>
        {nextPageUrl && (
          <Button
            title="more"
            onClick={() =>
              reaction.history.extendPageContentWithPagination(
                nextPageUrl,
                'payslips'
              )
            }
          />
        )}
      </Stack>
    </Layout>
  );
}
