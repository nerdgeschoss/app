import React from 'react';
import { PageProps } from '../../../data.d';
import { useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { ProjectCard } from '../../frontend/components/project_card/project_card';
import { Grid } from '../../frontend/components/grid/grid';
import { Button } from '../../frontend/components/button/button';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Link } from '../../frontend/sprinkles/history';
import { Pill } from '../../frontend/components/pill/pill';

export default function ({
  data: { currentUser, projects, nextPageUrl, currentSprint, filter },
}: PageProps<'projects/index'>): JSX.Element {
  const t = useTranslate();
  const reaction = useReaction();

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Text type="h1-bold">{t('projects.index.title')}</Text>
        <Stack line="mobile" size={4}>
          {['active', 'internal', 'archived'].map((e) => (
            <Link key={e} href={`/projects?filter=${e}`}>
              <Pill active={e === filter}>{e}</Pill>
            </Link>
          ))}
        </Stack>
        <Grid minColumnWidth={500}>
          {projects.map((project) => (
            <ProjectCard
              key={project.id}
              sprintName={currentSprint?.title ?? null}
              {...project}
            />
          ))}
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
