import type { DataSchema } from '../../../data.d.ts';

export type LeaveType = NonNullable<
  DataSchema['sprint_feedbacks/show']['feedback']['days'][number]['leave']
>['type'];
