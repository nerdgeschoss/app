import { Text } from '../text/text';
import './text_box.scss';
import { type ReactElement } from 'react';

interface Props {
  text?: string;
}

export function TextBox({ text }: Props): ReactElement {
  return (
    <div className="text-box">
      <Text type="body-secondary-regular" color="label-body-primary">
        {text}
      </Text>
    </div>
  );
}
