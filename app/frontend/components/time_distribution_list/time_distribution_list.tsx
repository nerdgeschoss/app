import './time_distribution_list.scss';
import classnames from 'classnames';
import React, { type ReactElement } from 'react';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';
import { CollapsePanel } from '../collapse_panel/collapse_panel';
import { Icon } from '../icon/icon';
import { Text } from '../text/text';
import { useFormatter } from '../../util/dependencies';
import { useSelection } from '../../util/basic_hooks';
import type { DataSchema } from '../../../../data.d.ts';

type Client =
  DataSchema['sprint_feedbacks/show']['feedback']['timeDistribution']['clients'][number];
type Project = Client['projects'][number];

export const SERIES_COLORS = Array.from(
  { length: 10 },
  (_, index) => `var(--chart-series-${index + 1})`
);

interface Props {
  clients: Array<Client & { color: string }>;
}

export function TimeDistributionList({ clients }: Props): ReactElement {
  const l = useFormatter();
  const openClients = useSelection<string>();

  return (
    <Stack gap={16}>
      {clients.map((client) => {
        const open = openClients.has(client.id);
        return (
          <div key={client.id} className="time-distribution-list__client">
            <button
              type="button"
              className="time-distribution-list__row time-distribution-list__row--client"
              aria-expanded={open}
              onClick={() => openClients.toggle(client.id)}
            >
              <div className="time-distribution-list__label">
                <span
                  className="time-distribution-list__dot"
                  style={{ background: client.color }}
                />
                <Text
                  type="caption-primary-regular"
                  color="label-caption-strong"
                >
                  {client.name}
                </Text>
              </div>
              <div className="time-distribution-list__value">
                <Text
                  type="caption-primary-regular"
                  color="label-caption-secondary"
                  noWrap
                >
                  {l.percentage(client.percentage)} ({l.hours(client.hours)}h)
                </Text>
                <span
                  className={classnames('time-distribution-list__chevron', {
                    'time-distribution-list__chevron--open': open,
                  })}
                >
                  <Icon name="chevron-arrow" size={10} color="active" />
                </span>
              </div>
            </button>
            <CollapsePanel open={open}>
              <div className="time-distribution-list__projects">
                <Stack gap={8}>
                  {client.projects.map((project) => (
                    <ProjectRow
                      key={project.id}
                      project={project}
                      color={client.color}
                    />
                  ))}
                </Stack>
              </div>
            </CollapsePanel>
          </div>
        );
      })}
    </Stack>
  );
}

function ProjectRow({
  project,
  color,
}: {
  project: Project;
  color: string;
}): ReactElement {
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
