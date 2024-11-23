import React from 'react';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';
import { PageProps } from '../../../data.d';

export default function ({
  data: { filter, users, currentUser },
}: PageProps<'users/index'>): JSX.Element {
  return (
    <>
      <Sidebar user={currentUser} />
      <div className="content">
        <div className="container">
          <div className="stack">
            <h1 className="headline">Users</h1>
            <div className="line line--space-between">
              <div className="stack stack--row stack--small stack--wrap">
                {['employee', 'sprinter', 'hr', 'archive'].map((e) => (
                  <a
                    key={e}
                    className={`pill ${e === filter ? 'active' : ''}`}
                    href={`/users?filter=${e}`}
                  >
                    {e}
                  </a>
                ))}
              </div>
            </div>
            {users.map((user) => (
              <div key={user.id} className="card">
                <div className="card__header">
                  <div className="card__icon">
                    <img src={user.avatarUrl} alt="" />
                  </div>
                  <div className="card__header-content">
                    <a
                      href={`/users/${user.id}`}
                      data-action="replace"
                      className="card__title"
                    >
                      {user.fullName} {user.nickName && `(${user.nickName})`}
                    </a>
                    <div className="card__subtitle">
                      {user.remainingHolidays} holidays left
                      {user.currentSalary && (
                        <div>
                          ${user.currentSalary.brut} since $
                          {user.currentSalary.validFrom}
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </>
  );
}

// .container: .stack
//   h1.headline = t ".users"
//   .line.line--space-between
//     .stack.stack--row.stack--small.stack--wrap
//       - (["employee", "sprinter", "hr", "archive"]).each do |filter|
//         a.pill class=("active" if filter == @filter) href=(url_for(filter:)) = t("user.filter.#{filter}")
//   = render @users
