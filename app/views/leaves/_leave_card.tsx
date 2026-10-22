import { JSX } from 'react';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { Card } from '../../frontend/components/card/card';
import { Avatar } from '../../frontend/components/avatar/avatar';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { Button } from '../../frontend/components/button/button';
import { StatusPill } from '../../frontend/components/status_pill/status_pill';
import { ClickTooltip } from '../../frontend/components/click_tooltip/click_tooltip';
import { useModal } from '../../frontend/components/modal/modal';
import { useReaction } from '../../frontend/sprinkles/reaction';

// Structural subset of the serialized leave, so the employee page can pass its
// leaves unchanged and the HR page its pending leaves, which carry no title.
export interface LeaveCardLeave {
  id: string;
  title?: string;
  status: string;
  unicodeEmoji: string;
  numberOfDays: string;
  days: Array<{ day: string }>;
  user?: {
    id: string;
    displayName: string;
    avatarUrl?: string;
    email?: string;
  };
  permitApprove: boolean;
  permitUpdate: boolean;
  permitDestroy: boolean;
}

interface Props {
  leave: LeaveCardLeave;
  showUser?: boolean;
  showStatus?: boolean;
}

export function LeaveCard({ leave, showUser, showStatus }: Props): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  const reaction = useReaction();
  const modal = useModal();

  const firstDay = leave.days[0]?.day;
  const lastDay = leave.days[leave.days.length - 1]?.day;

  // exact days grouped by month, "Dec 30, 31, Jan 1, 2"; the month name comes
  // from a local date, new Date(isoDay) is UTC midnight and shifts the 1st to
  // the previous month west of UTC
  const dayGroups: string[][] = [];
  leave.days.forEach(({ day }) => {
    const group = dayGroups[dayGroups.length - 1];
    if (group && group[0].slice(0, 7) === day.slice(0, 7)) {
      group.push(day);
    } else {
      dayGroups.push([day]);
    }
  });
  const daysLabel = dayGroups
    .map((group) => {
      const month = l.monthShort(
        new Date(Number(group[0].slice(0, 4)), Number(group[0].slice(5, 7)) - 1)
      );
      const numbers = group.map((day) => Number(day.slice(8, 10)));
      return `${month ?? ''} ${numbers.join(', ')}`;
    })
    .join(', ');

  const patchStatus = (status: 'approved' | 'rejected') =>
    reaction.call({
      path: `/leaves/${leave.id}`,
      method: 'PATCH',
      params: { leave: { status } },
      refresh: true,
    });

  return (
    <Card
      id={`leave_${leave.id}`}
      withDivider
      highlight={
        leave.status === 'pending_approval'
          ? 'warning'
          : leave.status === 'rejected'
            ? 'danger'
            : undefined
      }
      icon={
        showUser && leave.user ? (
          <Avatar
            displayName={leave.user.displayName}
            avatarUrl={leave.user.avatarUrl}
            email={leave.user.email ?? ''}
          />
        ) : (
          leave.unicodeEmoji
        )
      }
      title={showUser ? leave.user?.displayName : leave.title}
      context={
        <Stack line="mobile" size={16} align="center">
          {showUser && <span>{leave.unicodeEmoji}</span>}
          <ClickTooltip
            trigger={<Text type="body-bold">{leave.numberOfDays}</Text>}
          >
            <Text type="tooltip-secondary" noWrap>
              {daysLabel}
            </Text>
          </ClickTooltip>
          {showStatus && leave.status === 'pending_approval' && (
            <StatusPill
              type="pending"
              title={t('leaves.types.pending_approval')}
            />
          )}
          {showStatus && leave.status === 'rejected' && (
            <StatusPill type="rejected" title={t('leaves.types.rejected')} />
          )}
        </Stack>
      }
    >
      <Stack line="mobile" justify="space-between" align="center">
        <Stack size={4}>
          <Text>{l.date(firstDay)}</Text>
          {lastDay && lastDay !== firstDay && <Text>{l.date(lastDay)}</Text>}
        </Stack>
        <Stack line="mobile" size={8}>
          {leave.permitApprove && (
            <>
              <Button
                variant="icon"
                tone="success"
                title="👍"
                onClick={() => patchStatus('approved')}
              />
              <Button
                variant="icon"
                tone="error"
                title="👎"
                onClick={() => patchStatus('rejected')}
              />
            </>
          )}
          {leave.permitUpdate && (
            <Button
              variant="icon"
              title="✏️"
              onClick={() => modal.present(`/leaves/${leave.id}/edit`)}
            />
          )}
          {leave.permitDestroy && !showUser && (
            <Button
              variant="icon"
              title="🗑️"
              onClick={() =>
                reaction.call({
                  path: `/leaves/${leave.id}`,
                  method: 'DELETE',
                  refresh: true,
                })
              }
            />
          )}
        </Stack>
      </Stack>
    </Card>
  );
}
