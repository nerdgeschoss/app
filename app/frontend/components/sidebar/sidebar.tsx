import './sidebar.scss';
import { Text } from '../text/text';
import { useState } from 'react';
import classNames from 'classnames';
import { Icon, IconName } from '../icon/icon';
import { Link, usePath } from '../../sprinkles/history';
import { Logo } from '../logo/logo';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';

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

  return (
    <nav className={classNames('sidebar', { 'sidebar--expanded': expanded })}>
      <div className="sidebar__header">
        <Logo />
        <div
          className="sidebar__menu-toggle"
          onClick={() => setExpanded((expanded) => !expanded)}
        />
      </div>
      <div className="sidebar__content">
        <div className="sidebar__links">
          <Stack gap={24} gapTablet={32} gapDesktop={48}>
            {links.map((link) => (
              <Link href={link.path} key={link.name}>
                <div
                  className={classNames('sidebar__link', {
                    'sidebar__link--active': link.active,
                  })}
                >
                  <Icon name={link.icon} size={24} desktopSize={32} />
                  <div className="sidebar__link-text">
                    <Text type="menu-semibold">{link.name}</Text>
                  </div>
                </div>
              </Link>
            ))}
          </Stack>
        </div>
        <div className="sidebar__footer">
          <Stack line align="center" gap={10}>
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
