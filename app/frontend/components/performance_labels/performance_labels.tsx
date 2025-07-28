import { useFormatter, useTranslate } from '../../util/dependencies';
import { Text } from '../text/text';
import './performance_labels.scss';
import { type ReactElement } from 'react';

interface Props {
  billableHours: number | null;
  trackedHours: number | null;
  hourGoal: number | null;
}

export function PerformanceLabels({
  billableHours,
  trackedHours,
  hourGoal,
}: Props): ReactElement {
  const l = useFormatter();
  const t = useTranslate();

  const missing = (hourGoal || 0) - (trackedHours || 0);

  return (
    <div className="performance-labels">
      <ul className="performance-labels__list">
        <li className="performance-labels__item performance-labels__item--billable">
          <span className="performance-labels__icon" />
          <Text type="caption-primary-regular" color="label-caption-secondary">
            {t('performance_labels.billable')}
          </Text>
          <span className="performance-labels__value">
            {l.hours(billableHours || 0)} {t('performance_labels.hrs')}
          </span>
        </li>
        <li className="performance-labels__item performance-labels__item--tracked">
          <span className="performance-labels__icon" />
          <Text type="caption-primary-regular" color="label-caption-secondary">
            {t('performance_labels.tracked')}
          </Text>
          <span className="performance-labels__value">
            {l.hours(trackedHours || 0)} {t('performance_labels.hrs')}
          </span>
        </li>
        <li className="performance-labels__item performance-labels__item--goal">
          <span className="performance-labels__icon" />
          <Text type="caption-primary-regular" color="label-caption-secondary">
            {t('performance_labels.goal')}
          </Text>
          <span className="performance-labels__value">
            {l.hours(hourGoal || 0)} {t('performance_labels.hrs')}
          </span>
        </li>
        <li className="performance-labels__item performance-labels__item--missing">
          <span className="performance-labels__icon" />
          <Text type="caption-primary-regular" color="label-caption-secondary">
            {t('performance_labels.missing')}
          </Text>
          <span className="performance-labels__value">
            {l.hours(missing)} {t('performance_labels.hrs')}
          </span>
        </li>
      </ul>
    </div>
  );
}
