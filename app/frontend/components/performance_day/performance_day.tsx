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
import { Link } from '../../sprinkles/history';

interface Props {
  day: Day;
}

export function PerformanceDay({ day }: Props): ReactElement {
  const l = useFormatter();
  const [expanded, setExpanded] = useState(false);
  const isToday = new Date(day.day).getDate() === new Date().getDate();

  const totalTrackedHours = day.trackedHours || 0;
  const totalProjectHours = day.timeEntries.reduce(
    (acc, entry) => acc + (parseFloat(entry.hours) || 0),
    0
  );

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
          <div className="performance-day__label">
            <Text type="button-hold" color="label-link-default">
              {expanded ? 'Show Less' : 'Show More'}
            </Text>
          </div>
          <div className="performance-day__icon">
            <Icon
              name="chevron-arrow"
              size={10}
              color="icon-arrow-secondary-active"
            />
          </div>
        </div>
      </header>
      <Collapse open={expanded}>
        <Spacer size={8} desktopSize={24} />
        <div className="performance-day__content">
          {day.timeEntries.length > 0 ? (
            <ul className="performance-day__table">
              <li className="performance-day__row performance-day__table-head">
                <div className="performance-day__cell">
                  <Text type="caption-primary-bold">Project</Text>
                </div>
                <div className="performance-day__cell">
                  <Text type="caption-primary-bold">Source</Text>
                </div>
                <div className="performance-day__cell">
                  <Text type="caption-primary-bold">Users</Text>
                </div>
                <div className="performance-day__cell">
                  <Text type="caption-primary-bold">Tracked</Text>
                </div>
                <div className="performance-day__cell">
                  <Text type="caption-primary-bold">Total</Text>
                </div>
              </li>
              {day.timeEntries.map((entry) => {
                const taskStatus = getPillType(entry.task?.status);

                return (
                  <li className="performance-day__row" key={entry.id}>
                    <div className="performance-day__cell performance-day__entry-details">
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
                    <div className="performance-day__cell performance-day__source">
                      <Icon name="github" size={20} />
                    </div>
                    <div className="performance-day__cell performance-day__users">
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
                    <div className="performance-day__cell performance-day__tracked performance-day__cell--justify-end">
                      {entry.hours && (
                        <>
                          <Text type="body-secondary-regular">
                            {entry.hours} hrs
                          </Text>
                          {entry.task?.totalHours && (
                            <span className="performance-day__mobile-total">
                              <span>/</span>
                              <Text type="body-bold">
                                {entry.task.totalHours} hrs
                              </Text>
                            </span>
                          )}
                        </>
                      )}
                    </div>
                    <div className="performance-day__cell performance-day__total performance-day__cell--justify-end">
                      {entry.task?.totalHours && (
                        <Text type="body-secondary-regular">
                          {entry.task.totalHours} hrs
                        </Text>
                      )}
                    </div>
                  </li>
                );
              })}
              <li className="performance-day__row performance-day__table-footer">
                <div className="performance-day__cell performance-day__entry-details">
                  <Text type="caption-primary-bold">Total</Text>
                </div>
                <div className="performance-day__cell performance-day__source" />
                <div className="performance-day__cell performance-day__users" />
                <div className="performance-day__cell performance-day__tracked performance-day__cell--justify-end">
                  <Text type="caption-primary-bold">
                    {l.singleDigitNumber(totalTrackedHours)} hrs
                  </Text>
                  {totalProjectHours && (
                    <span className="performance-day__mobile-total">
                      <span>/</span>
                      <Text type="body-bold">{totalProjectHours} hrs</Text>
                    </span>
                  )}
                </div>
                <div className="performance-day__cell performance-day__total performance-day__cell--justify-end">
                  <Text type="caption-primary-bold">
                    {l.singleDigitNumber(totalProjectHours)} hrs
                  </Text>
                </div>
              </li>
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
            <Stack gap={16}>
              {day.hasDailyNerdMessage ? (
                <TextBox text={day.dailyNerdMessage?.message} />
              ) : (
                <Text>No daily nerd left for this day.</Text>
              )}
              {isToday && (
                <Stack justify="end" gap={0}>
                  <Link href="/">
                    <Button
                      title={
                        day.hasDailyNerdMessage
                          ? 'Update Daily Nerd'
                          : 'Add Daily Nerd'
                      }
                    />
                  </Link>
                </Stack>
              )}
            </Stack>
          </Stack>
        </div>
      </Collapse>
    </div>
  );
}
