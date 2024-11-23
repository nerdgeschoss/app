import React from 'react';
import logo from '../../../frontend/images/logo.svg';

interface Props {
  user: {
    id: string;
    displayName: string;
    avatarUrl: string;
  };
}

export function Sidebar({ user }: Props): JSX.Element {
  return (
    <nav className="sidebar">
      <a className="sidebar__header" href="/">
        <img className="sidebar__logo" src={logo} alt="logo" />
      </a>
      <div className="sidebar__links">
        <a className="sidebar__link" href="/sprints">
          Sprint
        </a>
        <a className="sidebar__link" href="/leaves">
          Leave
        </a>
        <a className="sidebar__link" href="/payslips">
          Payslip
        </a>
        <a className="sidebar__link" href="/users">
          User
        </a>
      </div>
      <div className="sidebar__footer">
        <a className="sidebar__avatar" href={`/users/${user.id}`}>
          <div className="sidebar__avatar-name">{user.displayName}</div>
          <img src={user.avatarUrl} alt="avatar" />
        </a>
      </div>
    </nav>
  );
}
