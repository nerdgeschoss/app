import { useFormatter, useTranslate } from '../../util/dependencies';
import { Card } from '../card/card';
import { Divider } from '../divider/divider';
import { Grid } from '../grid/grid';
import { IconLink } from '../icon_link/icon_link';
import { Stack } from '../stack/stack';
import { Text } from '../text/text';
import { DependencyIcon } from './dependency_icon';
import { DetailLine } from './detail_line';

interface Props {
  name: string;
  clientName: string;
  githubUrl: string | null;
  harvestUrl: string | null;
  frameworkVersions: Record<string, string>;
  openInvoiceAmount: number | null;
  openInvoiceCount: number | null;
  invoicedRevenue: number | null;
  uninvoicedRevenue: number | null;
  lastInvoiced: string | null;
}

export function ProjectCard({
  name,
  clientName,
  frameworkVersions,
  githubUrl,
  openInvoiceAmount,
  openInvoiceCount,
  lastInvoiced,
  invoicedRevenue,
  uninvoicedRevenue,
  harvestUrl,
}: Props): JSX.Element {
  const l = useFormatter();
  const t = useTranslate();
  return (
    <Card>
      <Stack size={16}>
        <Stack size={4}>
          <Text type="h5-bold">{name}</Text>
          <Text type="caption-primary-regular" color="label-caption-secondary">
            {clientName}
          </Text>
        </Stack>
        <Divider />
        <Stack line="mobile">
          {githubUrl && (
            <IconLink
              title={t('projects.index.github')}
              icon="github"
              href={githubUrl}
            />
          )}
        </Stack>
        <Grid gap={8} horizontalGap={24} minColumnWidth={230}>
          {openInvoiceAmount !== null && openInvoiceAmount > 0 && (
            <DetailLine
              label={t('projects.index.open_invoices')}
              value={
                (openInvoiceCount ?? 0) > 1
                  ? `${l.currency(openInvoiceAmount)} (${openInvoiceCount})`
                  : l.currency(openInvoiceAmount)
              }
              icon="harvest"
              iconUrl={harvestUrl ?? undefined}
            />
          )}
          {invoicedRevenue !== null && invoicedRevenue > 0 && (
            <DetailLine
              label={t('projects.index.invoiced_revenue')}
              value={l.currency(invoicedRevenue)}
            />
          )}
          {uninvoicedRevenue !== null && uninvoicedRevenue > 0 && (
            <DetailLine
              label={t('projects.index.uninvoiced_revenue')}
              value={l.currency(uninvoicedRevenue)}
            />
          )}
          {lastInvoiced && (
            <DetailLine
              label={t('projects.index.last_invoiced')}
              value={l.date(lastInvoiced)}
            />
          )}
        </Grid>
        {Object.keys(frameworkVersions).length > 0 && (
          <>
            <Divider />
            <Stack
              size={8}
              line="mobile"
              align="center"
              justify="space-between"
            >
              {Object.entries(frameworkVersions)
                .sort(([nameA], [nameB]) => nameA.localeCompare(nameB))
                .map(([name, version]) => (
                  <Stack line="mobile" key={name} size={8}>
                    <DependencyIcon name={name} />
                    <Text key={name} type="caption-primary-regular" noWrap>
                      {version}
                    </Text>
                  </Stack>
                ))}
            </Stack>
          </>
        )}
      </Stack>
    </Card>
  );
}
