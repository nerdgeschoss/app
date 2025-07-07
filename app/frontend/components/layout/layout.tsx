import './layout.scss';
import { ReactNode } from 'react';
import { Container } from '../container/container';
import { Sidebar } from '../sidebar/sidebar';

interface Props {
  user?: {
    id: string;
    displayName: string;
    avatarUrl: string;
  };
  children: ReactNode;
  container?: boolean;
}

export function Layout({ user, children, container }: Props): JSX.Element {
  return (
    <div className="layout">
      {user && (
        <div className="layout__sidebar">
          <Sidebar user={user} />
        </div>
      )}
      {container ? (
        <main className="layout__content">
          <Container>{children}</Container>
        </main>
      ) : (
        <main className="layout__content">{children}</main>
      )}
    </div>
  );
}
