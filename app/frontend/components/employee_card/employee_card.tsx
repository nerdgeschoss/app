import { useFormatter, useTranslate } from '../../util/dependencies';
import { Button } from '../button/button';
import { Divider } from '../divider/divider';
import { IconTitle } from '../icon_title/icon_title';
import { useModal } from '../modal/modal';
import { PerformanceDay } from '../performance_day/performance_day';
import { PerformanceDays } from '../performance_days/performance_days';
import { PerformanceLabels } from '../performance_labels/performance_labels';
import { PerformanceProgress } from '../performance_progress/performance_progress';
import { Property } from '../property/property';
import { StackBarChart } from '../stack_bar_chart/stack_bar_chart';
import { StarField } from '../star_field/star_field';
import { TextBox } from '../text_box/text_box';
import {
  SERIES_COLORS,
  TimeDistributionList,
} from '../time_distribution_list/time_distribution_list';
import './employee_card.scss';
import React, { type ReactElement } from 'react';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';
import type { DataSchema } from '../../../../data.d.ts';

interface Props {
  id: string;
  finishedStorypoints: number;
  finishedStorypointsPerDay: number;
  retroRating: number | null;
  workingDayCount: number;
  turnoverPerStorypoint: number | null;
  turnover: number | null;
  targetTotalHours: number;
  targetBillableHours: number;
  trackedHours: number;
  billableHours: number;
  days: DataSchema['sprint_feedbacks/show']['feedback']['days'];
  retroText: string | null;
  timeDistribution: DataSchema['sprint_feedbacks/show']['feedback']['timeDistribution'];
}

export function EmployeeCard({
  id,
  finishedStorypoints,
  finishedStorypointsPerDay,
  retroRating,
  workingDayCount,
  turnoverPerStorypoint,
  turnover,
  targetTotalHours,
  targetBillableHours,
  trackedHours,
  billableHours,
  days,
  retroText,
  timeDistribution,
}: Props): ReactElement {
  const l = useFormatter();
  const modal = useModal();
  const t = useTranslate();

  const coloredClients = timeDistribution.clients.map((client, index) => ({
    ...client,
    color: SERIES_COLORS[index % SERIES_COLORS.length],
  }));

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
            value={l.singleDigitNumber(finishedStorypointsPerDay)}
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
            targetTotalHours={targetTotalHours}
          />
          <div className="employee-card__horizontal-divider">
            <Divider />
          </div>
        </Stack>
        <div className="employee-card__middle-column">
          <Stack gap={24}>
            <Stack gap={24}>
              <IconTitle
                icon="⏱️"
                title={t('employee_card.time_distribution')}
                color="var(--icon-header-series3)"
              />
              <StackBarChart
                data={coloredClients.map((client) => ({
                  value: client.percentage,
                  color: client.color,
                }))}
              />
              <TimeDistributionList clients={coloredClients} />
            </Stack>
            <div className="employee-card__horizontal-divider">
              <Divider />
            </div>
          </Stack>
        </div>
        <Stack gap={32}>
          <IconTitle
            icon="⏱️"
            title={t('employee_card.daily_overview')}
            color="var(--icon-header-series2)"
          />
          <PerformanceDays
            days={days.map((e) => ({
              ...e,
              href: `#performance-day-${e.id}`,
            }))}
            large
          />
        </Stack>
      </section>
      <Divider />
      <section className="employee-card__section employee-card__section--middle">
        <Stack gap={16}>
          <Stack gap={24}>
            <IconTitle
              icon="⭐"
              title={t('employee_card.retrospective')}
              color="var(--icon-header-series2-2)"
            />
            {retroRating !== null && <StarField value={retroRating} />}
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
