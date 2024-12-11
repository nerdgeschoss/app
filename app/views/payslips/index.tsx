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

export default function Home({
  data: { currentUser, payslips, nextPageUrl },
}: PageProps<'payslips/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="headline">
          {t('pages.home.hello', { name: currentUser.displayName })}
        </Text>
        <Columns>
          {payslips.map((payslip) => (
            <Card
              key={payslip.id}
              icon="💸"
              title={payslip.user.displayName}
              subtitle={l.monthAndYear(payslip.month)}
            />
          ))}
        </Columns>
        {nextPageUrl && (
          <Button
            title="more"
            onClick={() =>
              reaction.history.extendPageContent(
                nextPageUrl,
                (state, page) => ({
                  ...state,
                  props: {
                    ...state.props,
                    payslips: [...state.props.payslips, ...page.props.payslips],
                    nextPageUrl: page.props.nextPageUrl,
                  },
                })
              )
            }
          />
        )}
      </Stack>
    </Layout>
  );
}
