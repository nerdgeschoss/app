import './performance_day.scss';
import { useFormatter, useTranslate } from '../../util/dependencies';
import { Icon } from '../icon/icon';
import { Day } from '../performance_days/performance_days';
import { Text } from '../text/text';
import { type ReactElement } from 'react';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';
import classnames from 'classnames';
import { getPillType, StatusPill } from '../status_pill/status_pill';
import { Avatar } from '../avatar/avatar';
import { Tooltip } from '../tooltip/tooltip';
import { IconTitle } from '../icon_title/icon_title';
import { TextBox } from '../text_box/text_box';

interface Props {
  day: Day;
}

export function PerformanceDay({ day }: Props): ReactElement {
  const l = useFormatter();
  const t = useTranslate();

  const totalTrackedHours = day.trackedHours || 0;

  return (
    <div className={classnames('performance-day')}>
      <header className="performance-day__header">
        <Text type="h4-bold">{l.dayName(day.day)}</Text>
        <Text type="caption-primary-regular" color="label-heading-secondary">
          {l.dateLongMonth(day.day)}
        </Text>
      </header>
      <div className="performance-day__content">
        {day.timeEntries?.length ? (
          <ul className="performance-day__table">
            <li className="performance-day__row performance-day__table-head">
              <div className="performance-day__cell">
                <Text type="caption-primary-bold">
                  {t('performance_day.project')}
                </Text>
              </div>
              <div className="performance-day__cell">
                <Text type="caption-primary-bold">
                  {t('performance_day.source')}
                </Text>
              </div>
              <div className="performance-day__cell">
                <Text type="caption-primary-bold">
                  {t('performance_day.users')}
                </Text>
              </div>
              <div className="performance-day__cell">
                <Text type="caption-primary-bold">
                  {t('performance_day.tracked')}
                </Text>
              </div>
              <div className="performance-day__cell">
                <Text type="caption-primary-bold">
                  {t('performance_day.total')}
                </Text>
              </div>
            </li>
            {day.timeEntries.map((entry) => {
              const taskStatus = getPillType(entry.task?.status);

              return (
                <li className="performance-day__row" key={entry.id}>
                  <div className="performance-day__cell performance-day__entry-details">
                    <div className="performance-day__entry-data">
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
                    </div>
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
                          {l.hours(entry.hours)} hrs
                        </Text>
                        {entry.task?.totalHours && (
                          <span className="performance-day__mobile-total">
                            <span>/</span>
                            <Text type="body-bold">
                              {l.hours(entry.task.totalHours)} hrs
                            </Text>
                          </span>
                        )}
                      </>
                    )}
                  </div>
                  <div className="performance-day__cell performance-day__total performance-day__cell--justify-end">
                    {entry.task?.totalHours && (
                      <Text type="body-secondary-regular">
                        {l.hours(entry.task.totalHours)} hrs
                      </Text>
                    )}
                  </div>
                </li>
              );
            })}
            <li className="performance-day__row performance-day__table-footer">
              <div className="performance-day__cell performance-day__entry-details">
                <Text type="caption-primary-bold">
                  {t('performance_day.total')}
                </Text>
              </div>
              <div className="performance-day__cell performance-day__source" />
              <div className="performance-day__cell performance-day__users" />
              <div className="performance-day__cell performance-day__tracked performance-day__cell--justify-end">
                <Text type="caption-primary-bold">
                  {l.hours(totalTrackedHours)} {t('performance_day.hrs')}
                </Text>
              </div>
              <div className="performance-day__cell performance-day__total performance-day__cell--justify-end"></div>
            </li>
          </ul>
        ) : (
          <Text>{t('performance_day.no_entries')}</Text>
        )}

        <Stack gap={24}>
          <IconTitle
            icon="✍️"
            title={t('performance_day.daily_nerd')}
            color="var(--icon-day-empty)"
          />
          <Stack gap={16}>
            {day.hasDailyNerdMessage ? (
              <TextBox text={day.dailyNerdMessage?.message} />
            ) : (
              <Text>{t('performance_day.no_daily_nerd')}</Text>
            )}
          </Stack>
        </Stack>
      </div>
    </div>
  );
}
