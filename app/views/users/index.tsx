import React from 'react';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../javascript/util/dependencies';

export default function ({
  data: { filter, users, currentUser },
}: PageProps<'users/index'>): JSX.Element {
  const t = useTranslate();
  const l = useFormatter();
  return (
    <>
      <Sidebar user={currentUser} />
      <div className="content">
        <div className="container">
          <div className="stack">
            <h1 className="headline">{t('users.index.title')}</h1>
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
                      {t('users.index.number_holidays_left', {
                        count: user.remainingHolidays,
                      })}
                      {user.currentSalary && (
                        <div>
                          {t('users.index.salary_since', {
                            amount: l.currency(user.currentSalary.brut),
                            date: l.date(user.currentSalary.validFrom),
                          })}
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
