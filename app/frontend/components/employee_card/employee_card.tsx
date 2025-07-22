import { useFormatter } from '../../util/dependencies';
import { Divider } from '../divider/divider';
import { Property } from '../property/property';
import { Text } from '../text/text';
import './employee_card.scss';
import { type ReactElement } from 'react';

interface Props {
  finishedStorypoints: number | null;
  finishedStorypointsPerDay: number | null;
  retroRating: number | null;
  workingDayCount: number | null;
  turnoverPerStorypoint?: number | null;
  turnover?: number | null;
}

export function EmployeeCard({
  finishedStorypoints,
  finishedStorypointsPerDay,
  retroRating,
  workingDayCount,
  turnoverPerStorypoint,
  turnover,
}: Props): ReactElement {
  const l = useFormatter();

  return (
    <div className="employee-card">
      <header className="employee-card__header">
        <ul className="employee-card__sprint-info">
          <li className="employee-card__info">
            <Property prefix="🔢" value={finishedStorypoints} suffix="pts" />
          </li>
          <li className="employee-card__info">
            <span className="employee-card__info-icon">⭐️</span>
            <Text type="chart-label-primary-bold">{retroRating || '-'}</Text>
            <Text
              type="chart-label-primary-regular"
              color="label-heading-secondary"
            >
              /5
            </Text>
          </li>
          <li className="employee-card__info">
            <span className="employee-card__info-icon">🔢</span>
            <Text type="chart-label-primary-bold">
              {finishedStorypointsPerDay}
            </Text>
            <Text
              type="chart-label-primary-regular"
              color="label-heading-secondary"
            >
              pts/day
            </Text>
          </li>
          <li className="employee-card__info">
            <span className="employee-card__info-icon">💻</span>
            <Text type="chart-label-primary-bold">{workingDayCount}</Text>
            <Text
              type="chart-label-primary-regular"
              color="label-heading-secondary"
            >
              days
            </Text>
          </li>
        </ul>
        <Divider />
        <ul className="employee-card__turnover-info">
          <li className="employee-card__info">
            <span className="employee-card__info-icon">💸</span>
            <Text type="chart-label-primary-bold">
              {l.currency(turnoverPerStorypoint || 0)}
            </Text>
            <Text
              type="chart-label-primary-regular"
              color="label-heading-secondary"
            >
              Per Point
            </Text>
          </li>
          <li className="employee-card__info">
            <span className="employee-card__info-icon">💰</span>
            <Text type="chart-label-primary-bold">
              {l.currency(turnover || 0)}
            </Text>
            <Text
              type="chart-label-primary-regular"
              color="label-heading-secondary"
            >
              Monthly total
            </Text>
          </li>
        </ul>
        <Divider />
      </header>
    </div>
  );
}
