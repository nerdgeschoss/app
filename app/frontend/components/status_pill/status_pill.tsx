import './status_pill.scss';
import classnames from 'classnames';
import { type ReactElement } from 'react';
import { Text } from '../text/text';

const PILL_STATUS = ['todo', 'in_progress', 'review', 'done'] as const;
type PillStatus = (typeof PILL_STATUS)[number];
// Leave approval states, kept out of PILL_STATUS so getPillType never gives a
// GitHub task status named "Pending" or "Rejected" a leave colour.
type LeavePillStatus = 'pending' | 'rejected';

export function getPillType(type?: string): PillStatus | null {
  return (
    (type ? PILL_STATUS.find((item) => item === type.toLowerCase()) : null) ??
    null
  );
}

interface Props {
  title: string;
  type: PillStatus | LeavePillStatus;
}

export function StatusPill({ title, type }: Props): ReactElement {
  return (
    <div className={classnames('status-pill', `status-pill--${type}`)}>
      <Text type="status-pill">{title}</Text>
    </div>
  );
}
