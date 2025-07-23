import { useFormatter } from '../../util/dependencies';
import { Divider } from '../divider/divider';
import { IconTitle } from '../icon_title/icon_title';
import { PerformanceProgress } from '../performance_progress/performance_progress';
import { Property } from '../property/property';
import './employee_card.scss';
import { type ReactElement } from 'react';

interface Props {
  finishedStorypoints: number | null;
  finishedStorypointsPerDay: number | null;
  retroRating: number | null;
  workingDayCount: number | null;
  turnoverPerStorypoint: number | null;
  turnover: number | null;
  targetTotalHours?: number;
  targetBillableHours?: number;
  trackedHours?: number;
  billableHours?: number;
}

export function EmployeeCard({
  finishedStorypoints,
  finishedStorypointsPerDay,
  retroRating,
  workingDayCount,
  turnoverPerStorypoint,
  turnover,
  targetTotalHours = 0,
  targetBillableHours = 0,
  trackedHours = 0,
  billableHours = 0,
}: Props): ReactElement {
  const l = useFormatter();

  return (
    <div className="employee-card">
      <header className="employee-card__header">
        <div className="employee-card__sprint-info">
          <Property prefix="🔢" value={finishedStorypoints} suffix="pts" />
          <Property prefix="⭐️" value={retroRating} suffix="/5" />
          <Property
            prefix="🔢"
            value={finishedStorypointsPerDay}
            suffix="pts/day"
          />
          <Property prefix="💻" value={workingDayCount} suffix="days" />
        </div>
        <Divider />
        {turnover !== null && turnoverPerStorypoint !== null && (
          <>
            <div className="employee-card__turnover-info">
              <Property
                prefix="💸"
                value={l.currency(turnoverPerStorypoint)}
                suffix="Per Point"
              />
              <Property
                prefix="💰"
                value={l.currency(turnover)}
                suffix="Monthly total"
              />
            </div>
            <Divider />
          </>
        )}
        <IconTitle
          icon="⏱️"
          title="Sprint Overview"
          color="var(--icon-header-series1)"
        />
        <PerformanceProgress
          totalHours={targetTotalHours}
          targetBillableHours={targetBillableHours}
          trackedHours={trackedHours}
          billableHours={billableHours}
        />
        <Divider />
        <IconTitle
          icon="⏱️"
          title="Daily Overview"
          color="var(--icon-header-series2)"
        />
        <Divider />
        <IconTitle
          icon="⭐"
          title="Retrospective"
          color="var(--icon-header-series2-2)"
        />
      </header>
    </div>
  );
}
