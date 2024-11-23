import React, { useState } from 'react';
import { PageProps } from '../../../data.d';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';

export default function Home({
  data: { currentUser, upcomingLeaves, payslips, remainingHolidays },
}: PageProps<'pages/home'>): JSX.Element {
  return (
    <>
      <Sidebar />
      <div className="content">
        <div className="container">
          <div className="stack">
            <h1 className="headline">Hello {currentUser.displayName}</h1>
            <div className="columns">
              {upcomingLeaves.length > 0 && (
                <div className="card">
                  <div className="card__header">
                    <div className="card__icon">🏝️</div>
                    <div className="card__header-content">
                      <div className="card__title">Upcoming Holidays</div>
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
                      <div className="card__title">Recent Payslips</div>
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
                    <div className="card__title">Remaining Holidays</div>
                    <div className="card__subtitle">
                      {remainingHolidays} days left
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
