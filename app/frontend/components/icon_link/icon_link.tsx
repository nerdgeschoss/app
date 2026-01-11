import { Icon, IconName } from '../icon/icon';
import { Stack } from '../stack/stack';
import { Text } from '../text/text';

interface Props {
  title: string;
  icon: IconName;
  href: string;
}

export function IconLink({ title, icon, href }: Props): JSX.Element {
  return (
    <a href={href} target="_blank" rel="noopener noreferrer">
      <Stack size={8} line="mobile">
        <Icon name={icon} size={20} />
        <Text>{title}</Text>
      </Stack>
    </a>
  );
}
