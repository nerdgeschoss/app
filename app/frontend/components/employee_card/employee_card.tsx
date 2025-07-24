import { useFormatter } from '../../util/dependencies';
import { Button } from '../button/button';
import { Divider } from '../divider/divider';
import { IconTitle } from '../icon_title/icon_title';
import { useModal } from '../modal/modal';
import { PerformanceDay } from '../performance_day/performance_day';
import { Day, PerformanceDays } from '../performance_days/performance_days';
import { PerformanceLabels } from '../performance_labels/performance_labels';
import { PerformanceProgress } from '../performance_progress/performance_progress';
import { Property } from '../property/property';
import { Stack } from '../stack/stack';
import { StarField } from '../star_field/star_field';
import { TextArea } from '../text_area/text_area';
import './employee_card.scss';
import React, { type ReactElement } from 'react';

interface Props {
  id: string;
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
  days: Day[];
  retroText: string | null;
}

export function EmployeeCard({
  id,
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
  days = [],
  retroText,
}: Props): ReactElement {
  const l = useFormatter();
  const modal = useModal();

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
      </header>
      <section className="employee-card__section">
        <Stack size={24}>
          <Stack size={32}>
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
          </Stack>
          <PerformanceLabels
            billableHours={billableHours}
            trackedHours={trackedHours}
            workingDayCount={workingDayCount}
          />
          <Divider />
        </Stack>
        <Stack size={24}>
          <Stack size={32}>
            <IconTitle
              icon="⏱️"
              title="Daily Overview"
              color="var(--icon-header-series2)"
            />
            <PerformanceDays days={days} large />
          </Stack>
          <Divider />
        </Stack>
        <Stack size={16}>
          <Stack size={24}>
            <IconTitle
              icon="⭐"
              title="Retrospective"
              color="var(--icon-header-series2-2)"
            />
            <StarField value={retroRating || 0} />
          </Stack>
          {retroText && <TextArea value={retroText} readOnly />}
          <Button
            title={retroText ? 'Edit feedback' : 'Leave feedback'}
            onClick={() =>
              modal.present(`/en/sprint_feedbacks/${id}/edit_retro`)
            }
          />
        </Stack>
      </section>
      <Divider />
      <section className="employee-card__section">
        <Stack size={24}>
          {days.map((day, index) => {
            return (
              <React.Fragment key={day.id}>
                <PerformanceDay day={day} />
                {index < days.length - 1 && <Divider />}
              </React.Fragment>
            );
          })}
        </Stack>
      </section>
    </div>
  );
}
