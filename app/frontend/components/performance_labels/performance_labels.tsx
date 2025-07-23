import { useFormatter } from '../../util/dependencies';
import { Text } from '../text/text';
import './performance_labels.scss';
import { type ReactElement } from 'react';

interface Props {
  billableHours: number | null;
  trackedHours: number | null;
  workingDayCount: number | null;
}

export function PerformanceLabels({
  billableHours,
  trackedHours,
  workingDayCount,
}: Props): ReactElement {
  const l = useFormatter();
  const hourGoal = (workingDayCount || 0) * 7.5;
  const missing = hourGoal - (trackedHours || 0);

  return (
    <div className="performance-labels">
      <ul className="performance-labels__list">
        <li className="performance-labels__item performance-labels__item--billable">
          <span className="performance-labels__icon" />
          <Text
            type="desktop-caption-primary-regular"
            color="label-caption-secondary"
          >
            Billable
          </Text>
          <span className="performance-labels__value">{billableHours} hrs</span>
        </li>
        <li className="performance-labels__item performance-labels__item--tracked">
          <span className="performance-labels__icon" />
          <Text
            type="desktop-caption-primary-regular"
            color="label-caption-secondary"
          >
            Tracked
          </Text>
          <span className="performance-labels__value">{trackedHours} hrs</span>
        </li>
        <li className="performance-labels__item performance-labels__item--goal">
          <span className="performance-labels__icon" />
          <Text
            type="desktop-caption-primary-regular"
            color="label-caption-secondary"
          >
            Goal
          </Text>
          <span className="performance-labels__value">{hourGoal} hrs</span>
        </li>
        <li className="performance-labels__item performance-labels__item--missing">
          <span className="performance-labels__icon" />
          <Text
            type="desktop-caption-primary-regular"
            color="label-caption-secondary"
          >
            Missing
          </Text>
          <span className="performance-labels__value">{missing} hrs</span>
        </li>
      </ul>
    </div>
  );
}
