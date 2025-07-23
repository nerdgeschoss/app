import { Stack } from '../stack/stack';
import { Text } from '../text/text';
import './property.scss';

interface Props {
  value: string | number | null;
  suffix?: string;
  prefix?: string;
}

export function Property({ value, suffix, prefix }: Props): JSX.Element {
  return (
    <Stack className="property" line="mobile" size={3} align="center">
      {prefix && <span className="property__prefix">{prefix}</span>}
      <Text type="card-heading-bold">{value ?? '-'}</Text>
      {suffix && (
        <Text type="card-heading-regular" color="label-heading-secondary">
          {suffix}
        </Text>
      )}
    </Stack>
  );
}
