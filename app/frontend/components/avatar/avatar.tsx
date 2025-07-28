import './avatar.scss';
import { type ReactElement } from 'react';
import classnames from 'classnames';
import { Text } from '../text/text';

interface Props {
  displayName?: string;
  avatarUrl?: string;
  email: string;
  large?: boolean;
}

export function Avatar({
  displayName,
  avatarUrl,
  email,
  large,
}: Props): ReactElement {
  const firstTwoLetters = displayName
    ? displayName.slice(0, 2).toUpperCase()
    : email.slice(0, 2).toUpperCase();

  return (
    <div className={classnames('avatar', { 'avatar--large': large })}>
      {avatarUrl ? (
        <img
          className="avatar__image"
          src={avatarUrl}
          alt={displayName || email}
        />
      ) : (
        <div className="avatar__placeholder">
          <Text type="h4-bold">{firstTwoLetters}</Text>
        </div>
      )}
    </div>
  );
}
