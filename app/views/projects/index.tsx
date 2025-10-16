import React from 'react';
import { PageProps } from '../../../data.d';
import { useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { Card } from '../../frontend/components/card/card';
import { Grid } from '../../frontend/components/grid/grid';
import { Button } from '../../frontend/components/button/button';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Link } from '../../frontend/sprinkles/history';
import { Pill } from '../../frontend/components/pill/pill';

export default function ({
  data: { currentUser, projects, nextPageUrl, filter },
}: PageProps<'projects/index'>): JSX.Element {
  const t = useTranslate();
  const reaction = useReaction();

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="h1-bold">{t('projects.index.title')}</Text>
        <Stack line="mobile" size={4}>
          {['active', 'archived'].map((e) => (
            <Link key={e} href={`/projects?filter=${e}`}>
              <Pill active={e === filter}>{e}</Pill>
            </Link>
          ))}
        </Stack>
        <Grid>
          {projects.map((project) => {
            return (
              <Card
                key={project.id}
                title={project.name}
                subtitle={
                  <Stack size={4}>
                    <div>{project.clientName}</div>
                    {project.openInvoiceCount > 0 &&
                      project.harvestInvoiceUrl && (
                        <a
                          href={project.harvestInvoiceUrl}
                          target="_blank"
                          rel="noreferrer"
                        >
                          <Text type="body-bold">
                            {t('projects.index.open_invoices')}
                          </Text>
                        </a>
                      )}
                    {project.githubUrl && (
                      <a
                        href={project.githubUrl}
                        target="_blank"
                        rel="noreferrer"
                      >
                        {project.repository}
                      </a>
                    )}
                    {Object.keys(project.frameworkVersions).length > 0 && (
                      <Stack size={0}>
                        {Object.entries(project.frameworkVersions).map(
                          ([name, version]) => (
                            <Text key={name} type="body-regular">
                              {name}: {version as string}
                            </Text>
                          )
                        )}
                      </Stack>
                    )}
                  </Stack>
                }
              />
            );
          })}
        </Grid>
        {nextPageUrl && (
          <Button
            title="more"
            onClick={() =>
              reaction.history.extendPageContentWithPagination(
                nextPageUrl,
                'projects'
              )
            }
          />
        )}
      </Stack>
    </Layout>
  );
}
