import { Stack } from '../stack/stack';
import { Text } from '../text/text';
import React, { useState } from 'react';
import logo from '../../../frontend/images/logo.svg';
import './sidebar.scss';
import classNames from 'classnames';
import { Icon, IconName } from '../icon/icon';
import { usePath } from '../../sprinkles/history';

interface Props {
  user: {
    id: string;
    displayName: string;
    avatarUrl: string;
  };
}

interface LinkInfo {
  name: string;
  path: string;
  icon: IconName;
  active: boolean;
}

export function Sidebar({ user }: Props): JSX.Element {
  const [expanded, setExpanded] = useState(false);
  const path = usePath().split('?')[0];
  const links: LinkInfo[] = [
    {
      name: 'Dashboard',
      path: '/',
      icon: 'dashboard',
      active: path === '/',
    },
    {
      name: 'Sprints',
      path: '/sprints',
      icon: 'sprint',
      active: path.startsWith('/sprints'),
    },
    {
      name: 'Leaves',
      path: '/leaves',
      icon: 'leave',
      active: path.startsWith('/leaves'),
    },
    {
      name: 'Payslips',
      path: '/payslips',
      icon: 'payslip',
      active: path.startsWith('/payslips'),
    },
    {
      name: 'Users',
      path: '/users',
      icon: 'user',
      active: path.startsWith('/users'),
    },
  ];
  console.table(links);
  return (
    <nav className={classNames('sidebar', { 'sidebar--expanded': expanded })}>
      <div className="sidebar__header">
        <img className="sidebar__logo" src={logo} alt="logo" />
        <div
          className="sidebar__menu-toggle"
          onClick={() => setExpanded((expanded) => !expanded)}
        />
      </div>
      <div className="sidebar__content">
        <div className="sidebar__links">
          <Stack size={24} tabletSize={32} desktopSize={48}>
            {links.map((link) => (
              <a
                className={classNames('sidebar__link', {
                  'sidebar__link--active': link.active,
                })}
                key={link.name}
                href={link.path}
              >
                <Icon name={link.icon} size={24} desktopSize={32} />
                <div className="sidebar__link-text">
                  <Text type="menu-semibold">{link.name}</Text>
                </div>
              </a>
            ))}
          </Stack>
        </div>
        <div className="sidebar__footer">
          <Stack line="mobile" align="center" size={10}>
            <img
              src={user.avatarUrl}
              className="sidebar__avatar"
              alt="avatar"
            />
            <div className="sidebar__footer-username">
              <Text type="menu-semibold">{user.displayName}</Text>
            </div>
          </Stack>
        </div>
      </div>
    </nav>
  );
}
