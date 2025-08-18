import './status_pill.scss';
import classnames from 'classnames';
import { type ReactElement } from 'react';
import { Text } from '../text/text';

const PILL_STATUS = [
  'todo',
  'in_progress',
  'review',
  'done',
  'rejected',
] as const;
export type PillStatus = (typeof PILL_STATUS)[number];

export function getPillType(type?: string): PillStatus | null {
  return (
    (type ? PILL_STATUS.find((item) => item === type.toLowerCase()) : null) ??
    null
  );
}

interface Props {
  title: string;
  type: PillStatus;
}

export function StatusPill({ title, type }: Props): ReactElement {
  return (
    <div className={classnames('status-pill', `status-pill--${type}`)}>
      <Text type="status-pill">{title}</Text>
    </div>
  );
}
