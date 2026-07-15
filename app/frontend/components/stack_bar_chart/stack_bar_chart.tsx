import './stack_bar_chart.scss';
import React, { type ReactElement } from 'react';

interface Segment {
  value: number;
  color: string;
}

interface Props {
  data: Segment[];
}

export function StackBarChart({ data }: Props): ReactElement {
  return (
    <div className="stack-bar-chart">
      {data.map((segment, index) => (
        <div
          key={index}
          className="stack-bar-chart__segment"
          style={
            {
              flexGrow: segment.value,
              background: segment.color,
            } as React.CSSProperties
          }
        />
      ))}
    </div>
  );
}
