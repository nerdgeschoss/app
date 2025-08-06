import { Stack } from '../stack/stack';
import { Text } from '../text/text';
import React from 'react';
import './performance.scss';
import { Link } from '../../sprinkles/history';
import { PerformanceProgress } from '../performance_progress/performance_progress';
import { PerformanceDays } from '../performance_days/performance_days';
import { LeaveType } from '../../util/types';

interface Props {
  id: string;
  retroRating: number | null;
  finishedStorypoints: number;
  trackedHours: number;
  billableHours: number;
  targetTotalHours: number;
  targetBillableHours: number;
  days: Array<{
    id: string;
    trackedHours?: number;
    targetTotalHours?: number;
    billableHours?: number;
    targetBillableHours?: number;
    hasDailyNerdMessage: boolean;
    leave: {
      id: string;
      type: LeaveType;
    } | null;
    hasTimeEntries: boolean;
    workingDay: boolean;
    day: string;
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
  trackedHours,
  billableHours,
  targetTotalHours,
  targetBillableHours,
}: Props): JSX.Element {
  return (
    <Link href={`/sprint_feedbacks/${id}`}>
      <div className="performance">
        <Stack size={11}>
          <Stack justify="center" align="center" line="mobile" size={6}>
            <img src={user.avatarUrl} className="performance__avatar" />
            <div className="performance__title">
              <Text type="card-heading-bold">{user.displayName}</Text>
            </div>
          </Stack>
          <Stack line="mobile" justify="space-between">
            <Stack line="mobile" size={8}>
              <span>🔢</span>
              <Text type="caption-primary-regular">{finishedStorypoints}</Text>
            </Stack>
            <div>
              <Stack line="mobile" size={8}>
                <span>⭐</span>
                <Text type="caption-primary-regular">{retroRating ?? '-'}</Text>
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
          <PerformanceDays days={days} />
        </Stack>
      </div>
    </Link>
  );
}
