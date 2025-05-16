import { Stack } from '../stack/stack';
import { Text } from '../text/text';
import React from 'react';
import './performance.scss';
import classNames from 'classnames';
import { Link } from '../../sprinkles/history';
import { PerformanceProgress } from '../performance_progress/performance_progress';

interface Props {
  id: string;
  workingDayCount: number;
  retroRating: number | null;
  finishedStorypoints: number;
  trackedHours: number;
  billableHours: number;
  targetTotalHours: number;
  targetBillableHours: number;
  days: Array<{
    id: string;
    day: string;
    workingDay: boolean;
    hasDailyNerdMessage: boolean;
    hasTimeEntries: boolean;
    leave: {
      id: string;
      type: string;
    } | null;
  }>;
  user: {
    id: string;
    displayName: string;
    avatarUrl: string;
  };
}

export function Performance({
  id,
  user,
  finishedStorypoints,
  retroRating,
  days,
  workingDayCount,
  trackedHours,
  billableHours,
  targetTotalHours,
  targetBillableHours
}: Props): JSX.Element {
  return (
    <Link href={`/sprint_feedbacks/${id}`}>
      <div className="performance">
        <Stack size={11}>
          <Stack justify="center" line="mobile" size={6}>
            <img src={user.avatarUrl} className="performance__avatar" />
            <Text>{user.displayName}</Text>
          </Stack>
          <Stack line="mobile" justify="space-between">
            <Stack line="mobile">
              <span>🔢</span>
              <Text>{finishedStorypoints}</Text>
            </Stack>
            <div>
              <Stack line="mobile">
                <span>⭐</span>
                <Text>{retroRating ?? '-'}</Text>
              </Stack>
            </div>
          </Stack>
          <Stack size={3} justify="center">
            <PerformanceProgress
              totalHours={targetTotalHours}
              targetBillableHours={targetBillableHours}
              trackedHours={trackedHours}
              billableHours={billableHours}
            />
          </Stack>
          <Stack size={3}>
            <div className="performance__icon-line">
              {days.map((day) => {
                return (
                  <div
                    key={`${day.id}-container`}
                    className="performance__day-container"
                  >
                    <div className="performance__daily-nerd-container">
                      {(
                        <div
                          className={classNames('performance__daily-nerd', {
                            'performance__daily-nerd--written':
                              day.hasDailyNerdMessage,
                          })}
                        />
                      )}
                    </div>
                    <div
                      className={classNames('performance__day', {
                        'performance__day--sick': day.leave?.type === 'sick',
                        'performance__day--vacation':
                          day.leave?.type === 'paid',
                        'performance__day--working': day.hasTimeEntries,
                        'performance__day--weekend': !day.workingDay,
                      })}
                    />
                  </div>
                );
              })}
            </div>
          </Stack>
        </Stack>
      </div>
    </Link>
  );
}
