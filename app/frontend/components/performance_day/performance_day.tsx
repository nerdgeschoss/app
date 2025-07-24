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
import { IconTitle } from '../icon_title/icon_title';
import { TextBox } from '../text_box/text_box';
import { Button } from '../button/button';

interface Props {
  day: Day;
}

export function PerformanceDay({ day }: Props): ReactElement {
  const l = useFormatter();
  const [expanded, setExpanded] = useState(false);
  const isToday = new Date(day.day).getDate() === new Date().getDate();

  if (expanded) {
    console.log({ day });
  }

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
          {day.timeEntries.length > 0 ? (
            <ul className="performance-day__table">
              {day.timeEntries.map((entry) => {
                const taskStatus = getPillType(entry.task?.status);

                return (
                  <li className="performance-day__row" key={entry.id}>
                    <div className="performance-day__entry-details">
                      <Text type="caption-primary-bold">
                        {entry.project?.name}
                      </Text>
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
                    </div>
                    <div className="performance-day__tracked">
                      <Text type="body-secondary-regular">
                        {entry.hours}{' '}
                        <span className="performance-day__unit">hrs</span>
                      </Text>
                    </div>
                    {entry.task?.users && (
                      <div className="performance-day__users">
                        {entry.task.users.map((item) => {
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
                    )}
                    {entry.task?.totalHours && (
                      <div className="performance-day__total">
                        <Text type="body-secondary-regular">
                          {entry.task?.totalHours}{' '}
                          <span className="performance-day__unit">hrs</span>
                        </Text>
                      </div>
                    )}
                    <div className="performance-day__source">
                      <Icon name="github" size={20} />
                    </div>
                  </li>
                );
              })}
            </ul>
          ) : (
            <Text>No time entries for this day.</Text>
          )}

          <Stack gap={24}>
            <IconTitle
              icon="✍️"
              title="Daily Nerd"
              color="var(--icon-day-empty)"
            />
            {(day.hasDailyNerdMessage || isToday) && (
              <Stack gap={16} align="end">
                {day.hasDailyNerdMessage && (
                  <TextBox text={day.dailyNerdMessage?.message} />
                )}
                {isToday && (
                  <Button
                    title={
                      day.hasDailyNerdMessage
                        ? 'Update Daily Nerd'
                        : 'Add Daily Nerd'
                    }
                  />
                )}
              </Stack>
            )}
          </Stack>
        </Stack>
      </Collapse>
    </div>
  );
}
