import { useFormatter, useTranslate } from '../../util/dependencies';
import { Text } from '../text/text';
import './performance_labels.scss';
import { type ReactElement } from 'react';

interface Props {
  billableHours: number;
  trackedHours: number;
  targetTotalHours: number;
}

export function PerformanceLabels({
  billableHours,
  trackedHours,
  targetTotalHours,
}: Props): ReactElement {
  const l = useFormatter();
  const t = useTranslate();

  const missing = targetTotalHours - trackedHours;

  return (
    <div className="performance-labels">
      <ul className="performance-labels__list">
        <li className="performance-labels__item performance-labels__item--billable">
          <span className="performance-labels__icon" />
          <Text type="caption-primary-regular" color="label-caption-secondary">
            {t('performance_labels.billable')}
          </Text>
          <span className="performance-labels__value">
            {l.hours(billableHours)} {t('performance_labels.hrs')}
          </span>
        </li>
        <li className="performance-labels__item performance-labels__item--tracked">
          <span className="performance-labels__icon" />
          <Text type="caption-primary-regular" color="label-caption-secondary">
            {t('performance_labels.tracked')}
          </Text>
          <span className="performance-labels__value">
            {l.hours(trackedHours)} {t('performance_labels.hrs')}
          </span>
        </li>
        <li className="performance-labels__item performance-labels__item--goal">
          <span className="performance-labels__icon" />
          <Text type="caption-primary-regular" color="label-caption-secondary">
            {t('performance_labels.goal')}
          </Text>
          <span className="performance-labels__value">
            {l.hours(targetTotalHours)} {t('performance_labels.hrs')}
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
