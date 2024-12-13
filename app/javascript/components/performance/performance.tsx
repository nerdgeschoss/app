import { Stack } from '../stack/stack';
import { Text } from '../text/text';
import React from 'react';
import './performance.scss';
import classNames from 'classnames';
import { useFormatter } from '../../util/dependencies';

interface Props {
  workingDayCount: number;
  retroRating: number | null;
  finishedStorypoints: number;
  trackedHours: number;
  billableHours: number;
  days: Array<{
    id: string;
    day: string;
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
  user,
  finishedStorypoints,
  retroRating,
  days,
  workingDayCount,
  trackedHours,
}: Props): JSX.Element {
  const l = useFormatter();
  const percentageOfRequiredHours =
    workingDayCount > 0 ? trackedHours / (workingDayCount * 7.5) : 1.0;
  return (
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
        <Stack size={2} align="center">
          <Text>{l.percentage(percentageOfRequiredHours)}</Text>
          <Text>{l.singleDigitNumber(trackedHours)} hrs</Text>
        </Stack>
        <Stack size={3}>
          <div className="performance__icon-line">
            {days.map((day) => (
              <div
                key={day.id}
                className={classNames('performance__day', {
                  'performance__day--sick': day.leave?.type === 'sick',
                  'performance__day--vacation': day.leave?.type === 'paid',
                  'performance__day--working': day.hasTimeEntries,
                })}
              />
            ))}
          </div>
          <div className="performance__icon-line">
            {days.map((day) => (
              <div
                key={day.id}
                className={classNames('performance__daily-nerd', {
                  'performance__daily-nerd--written': day.hasDailyNerdMessage,
                })}
              />
            ))}
          </div>
        </Stack>
      </Stack>
    </div>
  );
}
