import React, { useState } from 'react';
import { PageProps } from '../../../data.d';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';
import { useTranslate } from '../../javascript/util/dependencies';

export default function Home({
  data: { currentUser, upcomingLeaves, payslips, remainingHolidays },
}: PageProps<'pages/home'>): JSX.Element {
  const t = useTranslate();
  return (
    <>
      <Sidebar user={currentUser} />
      <div className="content">
        <div className="container">
          <div className="stack">
            <h1 className="headline">
              {t('pages.home.hello', { name: currentUser.displayName })}
            </h1>
            <div className="columns">
              {upcomingLeaves.length > 0 && (
                <div className="card">
                  <div className="card__header">
                    <div className="card__icon">🏝️</div>
                    <div className="card__header-content">
                      <div className="card__title">
                        {t('pages.home.upcoming_holidays')}
                      </div>
                      <div className="stack stack--mini">
                        {upcomingLeaves.map((leave) => (
                          <div key={leave.id} className="card__subtitle">
                            {leave.startDate}, {leave.endDate}, {leave.title}
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              )}
              {payslips.length > 0 && (
                <div className="card">
                  <div className="card__header">
                    <div className="card__icon">💸</div>
                    <div className="card__header-content">
                      <div className="card__title">
                        {t('pages.home.last_payments')}
                      </div>
                      <div className="stack stack--mini">
                        {payslips.map((payslip) => (
                          <div key={payslip.id} className="card__subtitle">
                            {payslip.month}
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              )}
              <div className="card">
                <div className="card__header">
                  <div className="card__icon">⏰</div>
                  <div className="card__header-content">
                    <div className="card__title">
                      {t('pages.home.remaining_holidays')}
                    </div>
                    <div className="card__subtitle">
                      {t('pages.home.number_holidays_left', {
                        count: remainingHolidays,
                      })}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
