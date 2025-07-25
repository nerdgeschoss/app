import './avatar.scss';
import { type ReactElement } from 'react';

interface Props {
  displayName?: string;
  avatarUrl?: string;
  email: string;
}

export function Avatar({ displayName, avatarUrl, email }: Props): ReactElement {
  const firstTwoLetters = displayName
    ? displayName.slice(0, 2).toUpperCase()
    : email.slice(0, 2).toUpperCase();

  return (
    <div className="avatar">
      {avatarUrl ? (
        <img src={avatarUrl} alt={displayName || email} />
      ) : (
        <div className="avatar-placeholder">{firstTwoLetters}</div>
      )}
    </div>
  );
}
