import React from 'react';
import './performance_progress.scss';
import { useFormatter } from '../../util/dependencies';
import { Stack } from '../stack/stack';
import { Text } from '../text/text';

interface Props {
  totalHours: number;
  trackedHours: number;
  billableHours: number;
  targetBillableHours: number;
}

const calculateTargetLinePosition = (percentage: number) => {
  // Convert percentage to radians, starting from top (-90 degrees or -π/2)
  // and accounting for the circle's -180 degree rotation
  const angle = percentage * Math.PI - Math.PI;

  // Outer radius should match circle radius (65)
  // Inner radius should start a bit further out than center
  const outerRadius = 70; // Matches circle radius
  const innerRadius = 60; // Starts closer to the edge

  // Calculate points using the adjusted angle and radii
  const outerX = 75 + outerRadius * Math.cos(angle);
  const outerY = 75 + outerRadius * Math.sin(angle);
  const innerX = 75 + innerRadius * Math.cos(angle);
  const innerY = 75 + innerRadius * Math.sin(angle);

  return {
    x1: innerX,
    y1: innerY,
    x2: outerX,
    y2: outerY,
  };
};

export function PerformanceProgress({
  totalHours,
  trackedHours,
  billableHours,
  targetBillableHours,
}: Props): JSX.Element {
  const l = useFormatter();

  const percentageOfRequiredHours =
    totalHours > 0 ? trackedHours / totalHours : 1.0;
  const percentageOfBillableHours =
    targetBillableHours > 0 ? billableHours / totalHours : 1.0;
  const percentageOfTargetBillableHours =
    totalHours > 0 ? targetBillableHours / totalHours : 1.0;

  const requiredStrokeDashoffset = Math.min(
    408,
    Math.max(204, 408 - percentageOfRequiredHours * 204)
  );
  const billableStrokeDashoffset = Math.min(
    408,
    Math.max(204, 408 - percentageOfBillableHours * 204)
  );

  const targetLinePos = calculateTargetLinePosition(
    percentageOfTargetBillableHours || 0
  );

  return (
    <div className="performance-progress">
      <div className="performance-progress__container">
        <svg>
          <circle
            className="performance-progress__border-track"
            cx="75"
            cy="75"
            r="65"
            transform="rotate(-180 75 75)"
          />
          <circle
            className="performance-progress__tracked"
            cx="75"
            cy="75"
            r="65"
            transform="rotate(-180 75 75)"
            strokeDashoffset={requiredStrokeDashoffset}
          />
          <circle
            className="performance-progress__billable"
            cx="75"
            cy="75"
            r="65"
            transform="rotate(-180 75 75)"
            strokeDashoffset={billableStrokeDashoffset}
          />
          {percentageOfTargetBillableHours && (
            <line
              className="performance-progress__target-line"
              x1={targetLinePos.x1}
              y1={targetLinePos.y1}
              x2={targetLinePos.x2}
              y2={targetLinePos.y2}
            />
          )}
        </svg>
        <div className="performance-progress__percentage">
          <Stack align="center" size={1}>
            <Text type="chart-label-primary-bold">
              {l.percentage(percentageOfRequiredHours)}
            </Text>
            <Stack line="mobile" align="center" size={3}>
              <Text type="chart-label-primary-regular">
                {l.singleDigitNumber(trackedHours)}
              </Text>
              <Text
                type="chart-label-primary-regular"
                color="label-body-secondary"
              >
                hrs
              </Text>
            </Stack>
          </Stack>
        </div>
      </div>
    </div>
  );
}
