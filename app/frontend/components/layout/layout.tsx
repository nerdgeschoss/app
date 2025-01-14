import { Container } from '../container/container';
import { Sidebar } from '../sidebar/sidebar';
import React, { ReactNode } from 'react';

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
    <>
      {user && <Sidebar user={user} />}
      {container ? (
        <div className="content">
          <Container>{children}</Container>
        </div>
      ) : (
        <div className="content">{children}</div>
      )}
    </>
  );
}
