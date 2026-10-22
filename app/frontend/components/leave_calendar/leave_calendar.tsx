import './leave_calendar.scss';

import classnames from 'classnames';
import { JSX, useCallback, useEffect, useRef, useState } from 'react';
import { useFormatter, useTranslate } from '../../util/dependencies';
import { isoDate, parseIsoDate } from '../../util/date';
import { Link } from '../../sprinkles/history';
import { Avatar } from '../avatar/avatar';
import { Button } from '../button/button';
import { Icon } from '../icon/icon';
import { Text } from '../text/text';

export interface LeaveCalendarRow {
  user: { id: string; displayName: string; avatarUrl: string; email: string };
  dayCounts: { paid: number; sick: number; nonWorking: number };
  leaves: Array<{
    id: string;
    type: string;
    status: string;
    unicodeEmoji: string;
    days: string[];
  }>;
}

interface Props {
  year: number;
  month: number; // 1-based
  rows: LeaveCalendarRow[];
  // ISO days that are weekends or Berlin public holidays
  nonWorkingDays: string[];
  previousMonthUrl: string;
  nextMonthUrl: string;
  rowUrl: (userId: string) => string;
  onEdit: (leaveId: string) => void;
}

interface OpenTooltip {
  leaveId: string;
  top: number;
  left?: number;
  right?: number;
}

export function LeaveCalendar({
  year,
  month,
  rows,
  nonWorkingDays,
  previousMonthUrl,
  nextMonthUrl,
  rowUrl,
  onEdit,
}: Props): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const rootRef = useRef<HTMLDivElement>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const tooltipRef = useRef<HTMLDivElement>(null);
  const openBar = useRef<{ leaveId: string; element: HTMLElement } | null>(
    null
  );
  const [tooltip, setTooltip] = useState<OpenTooltip | null>(null);

  const closeTooltip = useCallback(() => {
    openBar.current = null;
    setTooltip(null);
  }, []);

  // The tooltip sits on the calendar root, outside the scrolling grid, because
  // the grid clips anything that sticks out of it: above the first row, past
  // the last day and most of the grid on phones. It follows the visible part
  // of its bar while the grid scrolls and opens towards the wider side.
  const placeTooltip = useCallback(() => {
    const open = openBar.current;
    const root = rootRef.current?.getBoundingClientRect();
    const grid = scrollRef.current?.getBoundingClientRect();
    if (!open || !root || !grid) {
      return;
    }
    const bar = open.element.getBoundingClientRect();
    const left = Math.max(bar.left, grid.left);
    const right = Math.min(bar.right, grid.right);
    if (left >= right) {
      closeTooltip();
      return;
    }
    const top = bar.top - root.top;
    setTooltip(
      left - root.left > root.width / 2
        ? { leaveId: open.leaveId, top, right: root.right - right }
        : { leaveId: open.leaveId, top, left: left - root.left }
    );
  }, [closeTooltip]);

  // click only: any click outside the open bar and the tooltip closes it; bar
  // clicks keep bubbling so they also close the other tooltips on the page
  useEffect(() => {
    const close = (event: MouseEvent): void => {
      const target = event.target as Node;
      if (
        openBar.current?.element.contains(target) ||
        tooltipRef.current?.contains(target)
      ) {
        return;
      }
      closeTooltip();
    };
    document.addEventListener('click', close);
    window.addEventListener('resize', placeTooltip);
    return () => {
      document.removeEventListener('click', close);
      window.removeEventListener('resize', placeTooltip);
    };
  }, [closeTooltip, placeTooltip]);

  // local dates only: new Date(isoString) is UTC midnight and lands on the
  // previous day west of UTC
  const daysInMonth = new Date(year, month, 0).getDate();
  const dayDates = Array.from(
    { length: daysInMonth },
    (_, i) => new Date(year, month - 1, i + 1)
  );
  const monthStart = isoDate(dayDates[0]);
  const monthEnd = isoDate(dayDates[daysInMonth - 1]);
  const offDays = new Set(nonWorkingDays);
  const isOff = (iso: string): boolean => offDays.has(iso);
  // working days share the card width, so a month fits on a desktop and only
  // scrolls once they would get narrower than 28px
  const gridTemplateColumns = dayDates
    .map((date) => (isOff(isoDate(date)) ? '22px' : 'minmax(28px, 1fr)'))
    .join(' ');

  const typeLabels: Record<string, string> = {
    paid: t('leaves.leave_types.paid'),
    sick: t('leaves.leave_types.sick'),
    non_working: t('leaves.leave_types.non_working'),
  };

  const openRow = rows.find((row) =>
    row.leaves.some((leave) => leave.id === tooltip?.leaveId)
  );
  const openLeave = openRow?.leaves.find(
    (leave) => leave.id === tooltip?.leaveId
  );

  return (
    <div className="leave-calendar" ref={rootRef}>
      <div className="leave-calendar__aside">
        <div className="leave-calendar__nav">
          <a
            href={previousMonthUrl}
            className="leave-calendar__arrow leave-calendar__arrow--previous"
            aria-label={t('leaves.hr_overview.previous_month')}
          >
            <Icon name="chevron-arrow" size={8} color="active" />
          </a>
          <div className="leave-calendar__title">
            <Text type="h3-bold" align="center">
              {l.monthShortAndYear(dayDates[0])}
            </Text>
          </div>
          <a
            href={nextMonthUrl}
            className="leave-calendar__arrow leave-calendar__arrow--next"
            aria-label={t('leaves.hr_overview.next_month')}
          >
            <Icon name="chevron-arrow" size={8} color="active" />
          </a>
        </div>
        {rows.map(({ user, dayCounts }) => (
          <Link
            key={user.id}
            href={rowUrl(user.id)}
            className="leave-calendar__user"
          >
            <Avatar
              displayName={user.displayName}
              avatarUrl={user.avatarUrl}
              email={user.email}
            />
            <div className="leave-calendar__user-text">
              <Text noWrap>{user.displayName}</Text>
              <div className="leave-calendar__counts">
                <Text type="body-bold" noWrap>{`🏖 ${dayCounts.paid}`}</Text>
                <Text type="body-bold" noWrap>{`🤒 ${dayCounts.sick}`}</Text>
                <Text type="body-bold" noWrap>
                  {`🧳 ${dayCounts.nonWorking}`}
                </Text>
              </div>
            </div>
          </Link>
        ))}
      </div>
      <div
        className="leave-calendar__scroll"
        ref={scrollRef}
        onScroll={placeTooltip}
      >
        <div className="leave-calendar__header" style={{ gridTemplateColumns }}>
          {dayDates.map((date) => (
            <div
              key={date.getDate()}
              className={classnames('leave-calendar__day', {
                'leave-calendar__day--non-working': isOff(isoDate(date)),
              })}
            >
              <Text
                type="caption-secondary-regular"
                color="label-caption-secondary"
                uppercase
              >
                {l.weekdayShort(date)}
              </Text>
              <Text type="caption-primary-bold">{date.getDate()}</Text>
            </div>
          ))}
        </div>
        {rows.map(({ user, leaves }) => {
          // sick leaves overlap the others, so a row holding both gets two
          // lanes: sick at the bottom, everything else at the top
          const lanes =
            new Set(
              leaves.map((leave) => (leave.type === 'sick' ? 'sick' : 'other'))
            ).size > 1;
          return (
            <div
              key={user.id}
              className="leave-calendar__row"
              style={{ gridTemplateColumns }}
            >
              {dayDates.map((date, i) => (
                <div
                  key={date.getDate()}
                  className={classnames('leave-calendar__cell', {
                    'leave-calendar__cell--non-working': isOff(isoDate(date)),
                  })}
                  style={{ gridColumn: i + 1, gridRow: 1 }}
                />
              ))}
              {leaves.flatMap((leave) => {
                // ISO day strings compare in date order
                const first = leave.days[0];
                const last = leave.days[leave.days.length - 1];
                if (!first || last < monthStart || first > monthEnd) {
                  return [];
                }
                const continuesBefore = first < monthStart;
                const continuesAfter = last > monthEnd;
                const startDay = continuesBefore
                  ? 1
                  : Number(first.slice(8, 10));
                const endDay = continuesAfter
                  ? daysInMonth
                  : Number(last.slice(8, 10));
                const leaveDays = new Set(leave.days);
                const sick = leave.type === 'sick';
                // every segment toggles the leave's tooltip and anchors it
                const toggleTooltip = (element: HTMLElement): void => {
                  if (openBar.current?.leaveId === leave.id) {
                    closeTooltip();
                    return;
                  }
                  openBar.current = { leaveId: leave.id, element };
                  placeTooltip();
                };
                // one segment per day of the range, so leave days, non-working
                // days and working days off the leave can look different
                return Array.from(
                  { length: endDay - startDay + 1 },
                  (_, i) => startDay + i
                ).map((d) => {
                  const iso = isoDate(new Date(year, month - 1, d));
                  const isLeaveDay = leaveDays.has(iso);
                  return (
                    <button
                      key={`${leave.id}-${d}`}
                      type="button"
                      className={classnames('leave-calendar__segment', {
                        'leave-calendar__segment--leave': isLeaveDay,
                        'leave-calendar__segment--off':
                          !isLeaveDay && isOff(iso),
                        'leave-calendar__segment--gap':
                          !isLeaveDay && !isOff(iso),
                        'leave-calendar__segment--pending':
                          leave.status === 'pending_approval',
                        'leave-calendar__segment--start': d === startDay,
                        'leave-calendar__segment--end': d === endDay,
                        'leave-calendar__segment--continues-before':
                          continuesBefore && d === startDay,
                        'leave-calendar__segment--continues-after':
                          continuesAfter && d === endDay,
                        'leave-calendar__segment--lane-top': lanes && !sick,
                        'leave-calendar__segment--lane-bottom': lanes && sick,
                      })}
                      style={{
                        gridColumn: d,
                        gridRow: 1,
                        alignSelf: lanes ? (sick ? 'end' : 'start') : 'center',
                      }}
                      data-leave-id={leave.id}
                      data-day={iso}
                      aria-label={
                        d === startDay ? undefined : leave.unicodeEmoji
                      }
                      aria-expanded={tooltip?.leaveId === leave.id}
                      onClick={(event) => toggleTooltip(event.currentTarget)}
                    >
                      {d === startDay && leave.unicodeEmoji}
                    </button>
                  );
                });
              })}
            </div>
          );
        })}
      </div>
      {tooltip && openRow && openLeave && (
        <div
          className="leave-calendar__tooltip"
          ref={tooltipRef}
          style={{ top: tooltip.top, left: tooltip.left, right: tooltip.right }}
        >
          <div className="leave-calendar__tooltip-content">
            <div>
              <Text type="tooltip-secondary" noWrap>
                {`${openRow.user.displayName}: ${typeLabels[openLeave.type] ?? openLeave.type}`}
              </Text>
              <Text type="tooltip-secondary" noWrap>
                {/* a one-day leave shows only its day */}
                {openLeave.days.length > 1
                  ? t('leaves.hr_overview.tooltip_range', {
                      from:
                        l.dayAndShortMonth(parseIsoDate(openLeave.days[0])) ??
                        '',
                      to:
                        l.dayAndShortMonth(
                          parseIsoDate(
                            openLeave.days[openLeave.days.length - 1]
                          )
                        ) ?? '',
                    })
                  : l.dayAndShortMonth(parseIsoDate(openLeave.days[0]))}
              </Text>
              <Text type="tooltip-secondary" noWrap>
                {openLeave.status === 'pending_approval'
                  ? t('leaves.types.pending_approval')
                  : t('leaves.types.approved')}
              </Text>
            </div>
            <Button
              variant="icon"
              title="✏️"
              onClick={() => {
                closeTooltip();
                onEdit(openLeave.id);
              }}
            />
          </div>
        </div>
      )}
    </div>
  );
}
