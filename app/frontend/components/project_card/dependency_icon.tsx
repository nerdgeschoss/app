import { IconName, Icon } from '../icon/icon';
import { Text } from '../text/text';

export function DependencyIcon({ name }: { name: string }): JSX.Element {
  const icons: Record<string, IconName> = {
    react: 'react',
    rails: 'rails',
    puma: 'puma',
    expo: 'expo',
  };
  const icon = icons[name];
  if (icon) {
    return (
      <div title={name}>
        <Icon name={icon} fullColor />
      </div>
    );
  }
  return (
    <Text type="caption-primary-regular" noWrap>
      {name}
    </Text>
  );
}
