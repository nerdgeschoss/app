import classNames from 'classnames';
import './performance_days.scss';
import { useFormatter } from '../../util/dependencies';
import { Text } from '../text/text';
import { Tooltip } from '../tooltip/tooltip';

export interface Day {
  id: string;
  day: string;
  workingDay: boolean;
  hasDailyNerdMessage: boolean;
  hasTimeEntries: boolean;
  leave: {
    id: string;
    type: string;
  } | null;
  trackedHours?: number;
  billableHours?: number;
  targetHours?: number;
  targetBillableHours?: number;
}

interface Props {
  days: Array<Day>;
  large?: boolean;
}

export function PerformanceDays({ days, large }: Props): JSX.Element {
  console.log(days);
  const l = useFormatter();

  return (
    <div
      className={classNames('performance-days', {
        'performance-days--large': large,
      })}
    >
      {days.map((day) => {
        const trackedHours = day.trackedHours || 0;
        const targetHours = day.targetHours || 0;
        const billableHours = day.billableHours || 0;
        const targetBillableHours = day.targetBillableHours || 0;

        const percentageTrackedHours =
          targetHours > 0 ? (trackedHours * 100) / targetHours : 0;
        const percentageBillableHours =
          targetHours > 0 ? (billableHours * 100) / targetHours : 0;
        const percentageTargetBillableHours =
          targetHours > 0 ? (targetBillableHours * 100) / targetHours : 0;

        return (
          <div
            key={`${day.id}-container`}
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
                  '--tracked-hours': `${percentageTrackedHours}%`,
                  '--billable-hours': `${percentageBillableHours}%`,
                  '--target-billable-hours': `${percentageTargetBillableHours}%`,
                } as React.CSSProperties
              }
            >
              <div className="performance-days__target" />
            </div>
            <div className="performance-days__day-label">
              <Text
                type="desktop-caption-secondary-regular"
                color="label-caption-secondary"
              >
                {l.date(day.day, { weekday: 'narrow' })}
              </Text>
            </div>
          </div>
        );
      })}
    </div>
  );
}
