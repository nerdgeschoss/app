import React from 'react';
import { PageProps } from '../../../data.d';
import { Card } from '../../javascript/components/card/card';
import { Columns } from '../../javascript/components/columns/columns';
import { Layout } from '../../javascript/components/layout/layout';
import { Stack } from '../../javascript/components/stack/stack';
import { Text } from '../../javascript/components/text/text';
import { Button } from '../../javascript/components/button/button';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';
import { useReaction } from '../../javascript/sprinkles/reaction';
import { useModal } from '../../javascript/components/modal/modal';

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
          <Text type="headline">
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
