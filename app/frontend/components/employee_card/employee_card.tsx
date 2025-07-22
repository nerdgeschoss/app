import { Text } from '../text/text';
import './employee_card.scss';
import { type ReactElement } from 'react';

interface Props {
  finishedStorypoints: number | null;
  finishedStorypointsPerDay: number | null;
  retroRating: number | null;
  workingDayCount: number | null;
}

export function EmployeeCard({
  finishedStorypoints,
  finishedStorypointsPerDay,
  retroRating,
  workingDayCount,
}: Props): ReactElement {
  return (
    <div className="employee-card">
      <ul className="employee-card__sprint-info">
        <li className="employee-card__info">
          <span className="employee-card__info-icon">🔢</span>
          <Text type="chart-label-primary-bold">{finishedStorypoints}</Text>
          <Text
            type="chart-label-primary-regular"
            color="label-heading-secondary"
          >
            pts
          </Text>
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
    </div>
  );
}
