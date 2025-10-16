import './sidebar.scss';
import { Text } from '../text/text';
import { useState } from 'react';
import classNames from 'classnames';
import { Icon, IconName } from '../icon/icon';
import { Link, usePath } from '../../sprinkles/history';
import { Logo } from '../logo/logo';
import { Stack } from '@nerdgeschoss/shimmer-component-stack';
import { Collapse } from '@nerdgeschoss/shimmer-component-collapse';
import { Tooltip } from '../tooltip/tooltip';
import { Avatar } from '../avatar/avatar';

interface Props {
  user: {
    id: string;
    displayName?: string;
    avatarUrl: string;
    email: string;
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
      name: 'Projects',
      path: '/projects',
      icon: 'project',
      active: path.startsWith('/projects'),
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
      <header aria-label="sidebar-header" className="sidebar__header">
        <div className="sidebar__brand">
          <Link href="/">
            <Logo />
          </Link>
          <div className="sidebar__company">
            <Text
              type="label-heading-primary"
              color="text-text-primary-base"
              uppercase
            >
              Nerdgeschoss
            </Text>
          </div>
        </div>
        <div
          className="sidebar__menu-toggle"
          onClick={() => setExpanded((expanded) => !expanded)}
        >
          <span className="sidebar__burger">
            <Icon name="menu" size={24} color="icon-menu-default" />
          </span>
          <div className="sidebar__close">
            <Icon name="close" size={24} color="icon-menu-default" />
          </div>
        </div>
      </header>
      <div className="sidebar__collapse">
        <Collapse open={expanded}>
          <div className="sidebar__mobile">
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
                        <Text
                          type="menu-semibold"
                          color="text-text-primary-base"
                        >
                          {link.name}
                        </Text>
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
              <Link href="/logout">
                <div className="sidebar__link">
                  <Icon name="logout" size={24} desktopSize={32} />
                  <div className="sidebar__link-text">
                    <Text type="menu-semibold" color="text-text-primary-base">
                      Logout
                    </Text>
                  </div>
                </div>
              </Link>
            </div>
          </div>
        </Collapse>
      </div>
      <div className="sidebar__links">
        <Stack gap={24} gapTablet={32} gapDesktop={48}>
          {links.map((link) => (
            <Link href={link.path} key={link.name}>
              <Tooltip content={link.name}>
                <div
                  className={classNames('sidebar__link', {
                    'sidebar__link--active': link.active,
                  })}
                >
                  <Icon name={link.icon} size={24} desktopSize={32} />
                </div>
              </Tooltip>
            </Link>
          ))}
        </Stack>
      </div>
      <div className="sidebar__footer">
        <Stack line align="center" gap={10}>
          <Avatar
            avatarUrl={user.avatarUrl}
            displayName={user.displayName}
            email={user.email}
            large
          />
          <div className="sidebar__footer-username">
            <Text type="menu-semibold">{user.displayName}</Text>
          </div>
        </Stack>
        <Link href="/logout">
          <Tooltip content="Logout">
            <div className="sidebar__link">
              <Icon name="logout" size={24} desktopSize={32} />
            </div>
          </Tooltip>
        </Link>
      </div>
    </nav>
  );
}
