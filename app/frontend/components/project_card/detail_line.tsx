import { ReactNode } from 'react';
import { IconName, Icon } from '../icon/icon';
import { Stack } from '../stack/stack';
import { Text } from '../text/text';

export function DetailLine({
  label,
  value,
  icon,
  iconUrl,
}: {
  label: string;
  value: ReactNode | string | null;
  icon?: IconName;
  iconUrl?: string;
}): JSX.Element {
  return (
    <Stack line="mobile" size={8} align="center">
      <Text type="caption-primary-regular" noWrap>
        {label}
      </Text>
      <Text type="caption-primary-bold" noWrap>
        {value}
      </Text>
      {icon && iconUrl && (
        <a href={iconUrl} target="_blank" rel="noreferrer">
          <Icon name={icon} fullColor />
        </a>
      )}
    </Stack>
  );
}
