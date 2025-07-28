import { useFormatter, useTranslate } from '../../util/dependencies';
import { Button } from '../button/button';
import { Divider } from '../divider/divider';
import { IconTitle } from '../icon_title/icon_title';
import { useModal } from '../modal/modal';
import { PerformanceDay } from '../performance_day/performance_day';
import { Day, PerformanceDays } from '../performance_days/performance_days';
import { PerformanceLabels } from '../performance_labels/performance_labels';
import { PerformanceProgress } from '../performance_progress/performance_progress';
import { Property } from '../property/property';
import { StarField } from '../star_field/star_field';
import { TextBox } from '../text_box/text_box';
import './employee_card.scss';
import React, { type ReactElement } from 'react';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';

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
  hourGoal: number | null;
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
  hourGoal,
}: Props): ReactElement {
  const l = useFormatter();
  const modal = useModal();
  const t = useTranslate();

  return (
    <div className="employee-card">
      <header className="employee-card__header">
        <div className="employee-card__sprint-info">
          <Property
            prefix="🔢"
            value={finishedStorypoints}
            suffix={t('employee_card.points')}
          />
          <Property prefix="⭐️" value={retroRating} suffix="/5" />
          <Property
            prefix="🔢"
            value={l.singleDigitNumber(finishedStorypointsPerDay || 0)}
            suffix={t('employee_card.points_per_day')}
          />
          <Property
            prefix="💻"
            value={workingDayCount}
            suffix={t('employee_card.days')}
          />
        </div>
        <Divider />
        {turnover !== null && turnoverPerStorypoint !== null && (
          <>
            <div className="employee-card__turnover-info">
              <Property
                prefix="💸"
                value={l.currency(turnoverPerStorypoint)}
                suffix={t('employee_card.per_point')}
              />
              <Property
                prefix="💰"
                value={l.currency(turnover)}
                suffix={t('employee_card.monthly_total')}
              />
            </div>
            <div className="employee-card__horizontal-divider">
              <Divider />
            </div>
          </>
        )}
      </header>
      <section className="employee-card__section employee-card__section--top">
        <Stack gap={24}>
          <Stack gap={32}>
            <IconTitle
              icon="⏱️"
              title={t('employee_card.sprint_overview')}
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
            hourGoal={hourGoal}
          />
          <div className="employee-card__horizontal-divider">
            <Divider />
          </div>
        </Stack>
        <div className="employee-card__daily-overview">
          <Stack gap={24}>
            <Stack gap={32}>
              <IconTitle
                icon="⏱️"
                title={t('employee_card.daily_overview')}
                color="var(--icon-header-series2)"
              />
              <PerformanceDays days={days} large />
            </Stack>
            <div className="employee-card__horizontal-divider">
              <Divider />
            </div>
          </Stack>
        </div>
        <Stack gap={16}>
          <Stack gap={24}>
            <IconTitle
              icon="⭐"
              title={t('employee_card.retrospective')}
              color="var(--icon-header-series2-2)"
            />
            <StarField value={retroRating || 0} />
          </Stack>
          <Stack gap={16} align="end">
            {retroText && <TextBox text={retroText} />}
            <Button
              title={
                retroText
                  ? t('employee_card.edit_feedback')
                  : t('employee_card.leave_feedback')
              }
              onClick={() =>
                modal.present(`/sprint_feedbacks/${id}/edit_retro`)
              }
            />
          </Stack>
        </Stack>
      </section>
      <Divider />
      <section className="employee-card__section employee-card__section--bottom">
        <Stack gap={24}>
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
