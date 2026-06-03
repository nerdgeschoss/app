import { JSX, useState } from 'react';
import { PageProps } from '../../../data.d';
import { useFormatter, useTranslate } from '../../frontend/util/dependencies';
import { Layout } from '../../frontend/components/layout/layout';
import { Stack } from '../../frontend/components/stack/stack';
import { Text } from '../../frontend/components/text/text';
import { PerformanceGrid } from '../../frontend/components/performance_grid/performance_grid';
import { Performance } from '../../frontend/components/performance/performance';
import { Card } from '../../frontend/components/card/card';
import { Button } from '../../frontend/components/button/button';
import { useModal } from '../../frontend/components/modal/modal';
import { useReaction } from '../../frontend/sprinkles/reaction';
import { Property } from '../../frontend/components/property/property';
import { Pill } from '../../frontend/components/pill/pill';
import { Table } from '../../frontend/components/table/table';
import { Tooltip } from '../../frontend/components/tooltip/tooltip';

export default function ({
  data: { currentUser, sprints, nextPageUrl, permitCreateSprint },
}: PageProps<'sprints/index'>): JSX.Element {
  const l = useFormatter();
  const t = useTranslate();
  const reaction = useReaction();
  const modal = useModal();
  const isHr =
    currentUser.roles.includes('hr') || currentUser.roles.includes('admin');
  const [displayMode, setDisplayMode] = useState<
    'performance' | 'retro' | 'points' | 'profits'
  >('performance');
  const displayModes = isHr
    ? (['performance', 'retro', 'points', 'profits'] as const)
    : (['performance', 'retro', 'points'] as const);

  return (
    <Layout user={currentUser} container>
      <Stack>
        <Stack line="mobile" justify="space-between">
          <Text type="h1-bold">{t('sprints.index.title')}</Text>
          {permitCreateSprint && (
            <Button
              title={t('sprints.index.create_sprint')}
              onClick={() => modal.present('/sprints/new')}
            />
          )}
        </Stack>
        <Stack size={32}>
          {sprints.map((sprint) => (
            <Stack key={sprint.id}>
              <Stack line="mobile" align="center">
                <Text type="h3-bold">🏃 {sprint.title}</Text>
                <Text type="h4-regular" color="label-heading-secondary">
                  {l.dateRangeLong(sprint.sprintFrom, sprint.sprintUntil)}
                </Text>
              </Stack>
              <Card
                withDivider
                subtitle={
                  <Stack line="mobile" wrap justify="space-between">
                    <Stack line="mobile" fullWidth={'none'} wrap>
                      <div>
                        <Property
                          prefix="🔢"
                          value={sprint.finishedStorypoints}
                          suffix="pts"
                        />
                      </div>
                      <div>
                        <Property
                          prefix="🔢"
                          value={l.singleDigitNumber(
                            sprint.finishedStorypointsPerDay
                          )}
                          suffix="pts/day"
                        />
                      </div>
                      <div>
                        <Property
                          prefix="⭐️"
                          value={l.singleDigitNumber(sprint.averageRating)}
                          suffix="/5"
                        />
                      </div>
                      <div>
                        <Property
                          prefix="💻"
                          value={sprint.totalWorkingDays}
                          suffix="days"
                        />
                      </div>
                    </Stack>
                    <Stack
                      line="mobile"
                      justifyDesktop="right"
                      fullWidth={'none'}
                      wrap
                    >
                      {sprint.revenuePerStorypoint !== null && (
                        <div>
                          <Property
                            prefix="💸"
                            value={l.currency(sprint.revenuePerStorypoint)}
                            suffix="per point"
                          />
                        </div>
                      )}
                      {sprint.profit !== null && (
                        <div>
                          <Property
                            prefix="💰"
                            value={l.currency(sprint.profit)}
                            suffix="Monthly total"
                          />
                        </div>
                      )}
                    </Stack>
                  </Stack>
                }
              >
                <Stack size={16}>
                  <Stack line="mobile" size={4}>
                    {displayModes.map((e) => (
                      <div onClick={() => setDisplayMode(e)} key={e}>
                        <Pill active={e === displayMode}>
                          {t(`sprints.index.statistic.${e}`)}
                        </Pill>
                      </div>
                    ))}
                  </Stack>
                  {displayMode === 'performance' && (
                    <PerformanceGrid>
                      {sprint.performances.map((performance) => (
                        <Performance key={performance.id} {...performance} />
                      ))}
                    </PerformanceGrid>
                  )}
                  {displayMode === 'retro' && (
                    <Stack>
                      {sprint.retroNotes.map((retro) => (
                        <Stack key={retro.id}>
                          <Stack line="mobile">
                            <Text type="card-heading-bold" noWrap>
                              {retro.user.displayName}
                            </Text>
                            <Stack line="mobile" size={8} align="center">
                              <span>⭐</span>
                              <Text type="caption-primary-regular">
                                {retro.retroRating ?? '-'}
                              </Text>
                            </Stack>
                          </Stack>
                          {retro.retroText && (
                            <Text multiline type="body-regular">
                              {retro.retroText}
                            </Text>
                          )}
                        </Stack>
                      ))}
                    </Stack>
                  )}
                  {displayMode === 'profits' && (
                    <Table>
                      <thead>
                        <tr>
                          <th>{t('profit.index.columns.user')}</th>
                          <th className="table__numeric">
                            {t('profit.index.columns.cost')}
                          </th>
                          <th className="table__numeric">
                            {t('profit.index.columns.revenue')}
                          </th>
                          <th className="table__numeric">
                            {t('profit.index.columns.profit')}
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        {sprint.profitRows.map((row) => (
                          <tr key={row.id}>
                            <td>{row.user.displayName}</td>
                            <td className="table__numeric">
                              <Tooltip
                                content={
                                  <>
                                    {row.salary !== 0 && (
                                      <div>
                                        {t(
                                          'profit.index.cost_breakdown.salary'
                                        )}
                                        : {l.currency(row.salary)}
                                      </div>
                                    )}
                                    {row.payrollTaxes !== 0 && (
                                      <div>
                                        {t(
                                          'profit.index.cost_breakdown.payroll_taxes'
                                        )}
                                        : {l.currency(row.payrollTaxes)}
                                      </div>
                                    )}
                                    {row.benefits !== 0 && (
                                      <div>
                                        {t(
                                          'profit.index.cost_breakdown.benefits'
                                        )}
                                        : {l.currency(row.benefits)}
                                      </div>
                                    )}
                                    {row.fixedShare !== 0 && (
                                      <div>
                                        {t(
                                          'profit.index.cost_breakdown.fixed_share'
                                        )}
                                        : {l.currency(row.fixedShare)}
                                      </div>
                                    )}
                                    {row.sickRefund !== 0 && (
                                      <div>
                                        {t(
                                          'profit.index.cost_breakdown.sick_refund'
                                        )}
                                        : {l.currency(-row.sickRefund)}
                                      </div>
                                    )}
                                  </>
                                }
                              >
                                <span>{l.currency(row.cost)}</span>
                              </Tooltip>
                            </td>
                            <td className="table__numeric">
                              {row.revenueByProject.length > 0 ? (
                                <Tooltip
                                  content={
                                    <>
                                      {row.revenueByProject.map((p) => (
                                        <div key={p.id}>
                                          {p.project}: {l.hours(p.hours)}h –{' '}
                                          {l.currency(p.revenue)}
                                        </div>
                                      ))}
                                    </>
                                  }
                                >
                                  <span>{l.currency(row.revenue)}</span>
                                </Tooltip>
                              ) : (
                                l.currency(row.revenue)
                              )}
                            </td>
                            <td className="table__numeric">
                              <Text
                                color={
                                  row.profit < 0 ? 'text-warning' : undefined
                                }
                              >
                                {l.currency(row.profit)}
                              </Text>
                            </td>
                          </tr>
                        ))}
                        <tr>
                          <td>
                            <Text type="body-bold">
                              {t('profit.index.total')}
                            </Text>
                          </td>
                          <td className="table__numeric">
                            <Text type="body-bold">
                              {l.currency(sprint.costs ?? 0)}
                            </Text>
                          </td>
                          <td className="table__numeric">
                            <Text type="body-bold">
                              {l.currency(sprint.revenue ?? 0)}
                            </Text>
                          </td>
                          <td className="table__numeric">
                            <Text
                              type="body-bold"
                              color={
                                (sprint.profit ?? 0) < 0
                                  ? 'text-warning'
                                  : undefined
                              }
                            >
                              {l.currency(sprint.profit ?? 0)}
                            </Text>
                          </td>
                        </tr>
                      </tbody>
                    </Table>
                  )}
                  {displayMode === 'points' && (
                    <Stack>
                      {sprint.storypointsPerDepartment.map((points) => (
                        <Stack
                          key={points.team}
                          line="mobile"
                          justify="space-between"
                        >
                          <Text type="body-regular">{points.team}</Text>
                          <Text type="body-regular">
                            {l.singleDigitNumber(points.points)} pts
                          </Text>
                          <Text type="body-regular">
                            {points.workingDays} days
                          </Text>
                          <Text type="body-regular">
                            {l.singleDigitNumber(points.pointsPerWorkingDay)}{' '}
                            pts/day
                          </Text>
                        </Stack>
                      ))}
                      <Stack line="mobile" justify="space-between">
                        <Text type="body-regular">
                          {t('sprints.index.total')}
                        </Text>
                        <Text type="body-regular">
                          {l.singleDigitNumber(
                            sprint.storypointsPerDepartment.reduce(
                              (acc, points) => acc + points.points,
                              0
                            )
                          )}{' '}
                          pts
                        </Text>
                        <Text type="body-regular"> </Text>
                        <Text type="body-regular"> </Text>
                      </Stack>
                    </Stack>
                  )}
                </Stack>
              </Card>
            </Stack>
          ))}
          {nextPageUrl && (
            <Button
              title={t('sprints.index.more')}
              onClick={() =>
                reaction.history.extendPageContentWithPagination(
                  nextPageUrl,
                  'sprints'
                )
              }
            />
          )}
        </Stack>
      </Stack>
    </Layout>
  );
}
