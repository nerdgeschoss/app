import { Collapse } from '@nerdgeschoss/shimmer-component-collapse';
import { useFormatter } from '../../util/dependencies';
import { Icon } from '../icon/icon';
import { Day } from '../performance_days/performance_days';
import { Text } from '../text/text';
import './performance_day.scss';
import { useState, type ReactElement } from 'react';
import { Spacer } from '../spacer/spacer';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';
import classnames from 'classnames';
import { getPillType, StatusPill } from '../status_pill/status_pill';
import { Avatar } from '../avatar/avatar';
import { Tooltip } from '../tooltip/tooltip';

interface Props {
  day: Day;
}

export function PerformanceDay({ day }: Props): ReactElement {
  const l = useFormatter();
  const [expanded, setExpanded] = useState(false);

  return (
    <div
      className={classnames('performance-day', {
        'performance-day--expanded': expanded,
      })}
    >
      <header
        className="performance-day__header"
        onClick={() => setExpanded((value) => !value)}
      >
        <Text type="h4-bold">{l.dayName(day.day)}</Text>
        <Text type="caption-primary-regular" color="label-heading-secondary">
          {l.date(day.day, {
            day: 'numeric',
            month: 'long',
            year: 'numeric',
          })}
        </Text>
        <div className="performance-day__toggle">
          <Icon
            name="chevron-arrow"
            size={10}
            color="icon-arrow-secondary-active"
          />
        </div>
      </header>
      <Collapse open={expanded}>
        <Spacer size={8} />
        <Stack gap={16}>
          <ul className="performance-day__table">
            {day.timeEntries.map((entry) => {
              const taskStatus = getPillType(entry.task?.status);

              return (
                <li key={entry.id}>
                  <Text type="caption-primary-bold">{entry.project?.name}</Text>
                  <Text type="body-secondary-regular">{entry.type}</Text>
                  <Text
                    type="body-secondary-regular"
                    color="label-heading-secondary"
                  >
                    {entry.notes}
                  </Text>
                  {taskStatus && (
                    <StatusPill type={taskStatus} title={taskStatus} />
                  )}
                  <Text type="body-secondary-regular">{entry.hours}</Text>
                  <div className="performance-day__users">
                    {entry.task?.users?.map((item) => {
                      return (
                        <Tooltip
                          key={item.id}
                          content={item.displayName || item.email}
                        >
                          <Avatar {...item} />
                        </Tooltip>
                      );
                    })}
                  </div>
                  <Text type="body-secondary-regular">
                    {entry.task?.totalHours}
                  </Text>
                  <Icon name="github" size={20} />
                </li>
              );
            })}
          </ul>
        </Stack>
      </Collapse>
    </div>
  );
}
