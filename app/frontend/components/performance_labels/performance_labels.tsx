import { useFormatter, useTranslate } from '../../util/dependencies';
import { Text } from '../text/text';
import './performance_labels.scss';
import classNames from 'classnames';
import { type ReactElement, type ReactNode } from 'react';

interface Props {
  billableHours: number;
  trackedHours: number;
  targetBillableHours: number;
  targetTotalHours: number;
}

export function PerformanceLabels({
  billableHours,
  trackedHours,
  targetBillableHours,
  targetTotalHours,
}: Props): ReactElement {
  const l = useFormatter();
  const t = useTranslate();

  const hours = (value: number): string =>
    `${l.hours(value)} ${t('performance_labels.hrs')}`;

  const missingBillable = Math.max(targetBillableHours - billableHours, 0);
  const missingTotal = Math.max(targetTotalHours - trackedHours, 0);

  return (
    <div className="performance-labels">
      <div className="performance-labels__sections">
        <Section title={t('performance_labels.tracked_target')}>
          <Item
            type="billable"
            label={t('performance_labels.billable')}
            value={`${hours(billableHours)} / ${hours(targetBillableHours)}`}
          />
          <Item
            type="total"
            label={t('performance_labels.total')}
            value={`${hours(trackedHours)} / ${hours(targetTotalHours)}`}
          />
        </Section>
        <Section title={t('performance_labels.missing')}>
          <Item
            label={t('performance_labels.billable')}
            value={hours(missingBillable)}
          />
          <Item
            label={t('performance_labels.total')}
            value={hours(missingTotal)}
          />
        </Section>
      </div>
    </div>
  );
}

function Section({
  title,
  children,
}: {
  title: string;
  children: ReactNode;
}): ReactElement {
  return (
    <section className="performance-labels__section">
      <Text type="caption-primary-bold">{title}</Text>
      <ul className="performance-labels__list">{children}</ul>
    </section>
  );
}

// Items without a type keep an empty icon column so values stay aligned
// with the colored items of the section above.
function Item({
  type,
  label,
  value,
}: {
  type?: 'billable' | 'total';
  label: string;
  value: string;
}): ReactElement {
  return (
    <li className="performance-labels__item">
      <span
        className={classNames(
          'performance-labels__icon',
          type && `performance-labels__icon--${type}`
        )}
      />
      <Text type="caption-primary-regular" color="label-caption-secondary">
        {label}
      </Text>
      <span className="performance-labels__value">{value}</span>
    </li>
  );
}
