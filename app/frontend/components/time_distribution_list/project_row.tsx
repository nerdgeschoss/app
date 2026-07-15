import React, { type ReactElement } from 'react';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';
import { Text } from '../text/text';
import { useFormatter } from '../../util/dependencies';
import type { DataSchema } from '../../../../data.d.ts';

type Client =
  DataSchema['sprint_feedbacks/show']['feedback']['timeDistribution']['clients'][number];
type Project = Client['projects'][number];

interface Props {
  project: Project;
  color: string;
}

export function ProjectRow({ project, color }: Props): ReactElement {
  const l = useFormatter();
  const hasName = Boolean(project.name);

  return (
    <Stack gap={8}>
      <div className="time-distribution-list__label">
        <span
          className="time-distribution-list__dot time-distribution-list__dot--small"
          style={{ background: hasName ? color : 'var(--chart-dot-empty)' }}
        />
        <Text type="caption-secondary-regular" color="label-caption-strong">
          {hasName ? project.name : '—'}
        </Text>
      </div>
      <div className="time-distribution-list__entries">
        <Stack gap={8}>
          {project.entries.map((entry) => (
            <Stack key={entry.id} gap={8} line justify="space-between">
              <Text
                type="caption-secondary-regular"
                color="label-caption-secondary"
              >
                {entry.task
                  ? `${entry.task.title}${entry.task.issueNumber ? ` #${entry.task.issueNumber}` : ''}`
                  : '—'}
              </Text>
              <Text
                type="caption-secondary-regular"
                color="label-caption-secondary"
                noWrap
              >
                {l.percentage(entry.percentage)} ({l.hours(entry.hours)}h)
              </Text>
            </Stack>
          ))}
        </Stack>
      </div>
    </Stack>
  );
}
