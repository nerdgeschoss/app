import './performance_days.scss';
import classNames from 'classnames';
import { useFormatter } from '../../util/dependencies';
import { Text } from '../text/text';
import { LeaveType } from '../../util/types';

interface Props {
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
  large?: boolean;
}

export function PerformanceDays({ days, large }: Props): JSX.Element {
  const l = useFormatter();

  return (
    <div
      className={classNames('performance-days', {
        'performance-days--large': large,
      })}
    >
      {days.map((day) => {
        const trackedHours = day.trackedHours ?? 0;
        const targetTotalHours = day.targetTotalHours ?? 0;
        const billableHours = day.billableHours ?? 0;
        const targetBillableHours = day.targetBillableHours ?? 0;

        const percentageTrackedHours =
          targetTotalHours > 0 ? (trackedHours * 100) / targetTotalHours : 0;
        const percentageBillableHours =
          targetTotalHours > 0 ? (billableHours * 100) / targetTotalHours : 0;
        const percentageTargetBillableHours =
          targetTotalHours > 0
            ? (targetBillableHours * 100) / targetTotalHours
            : 0;

        return (
          <a
            key={day.id}
            href={`#performance-day-${day.id}`}
            className="performance-days__day-container"
          >
            <div className="performance-days__daily-nerd-container">
              {
                <div
                  className={classNames('performance-days__daily-nerd', {
                    'performance-days__daily-nerd--written':
                      day.hasDailyNerdMessage,
                  })}
                />
              }
            </div>

            <div
              className={classNames('performance-days__day', {
                'performance-days__day--sick': day.leave?.type === 'sick',
                'performance-days__day--vacation': day.leave?.type === 'paid',
                'performance-days__day--working': day.hasTimeEntries,
                'performance-days__day--weekend': !day.workingDay,
              })}
              style={
                {
                  '--tracked-hours': `${Math.min(percentageTrackedHours, 100)}%`,
                  '--billable-hours': `${Math.min(percentageBillableHours, 100)}%`,
                  '--target-billable-hours': `${Math.min(percentageTargetBillableHours, 100)}%`,
                } as React.CSSProperties
              }
            >
              <div className="performance-days__target" />
            </div>
            <div className="performance-days__day-label">
              <Text
                type="caption-secondary-regular"
                color="label-caption-secondary"
              >
                {l.narrowWeek(day.day)}
              </Text>
            </div>
          </a>
        );
      })}
    </div>
  );
}
