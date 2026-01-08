export interface DataSchema {
  'components/_current_user': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
  };
  'inventories/edit': {
    inventory: {
      id: string;
      name: string;
      details: string | null;
      receivedAt: string;
      returnedAt: string | null;
    };
  };
  'inventories/new': {
    user: {
      id: string;
    };
  };
  'leaves/index': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    feedUrl: string;
    activeFilter: string;
    permitUserSelect: boolean;
    users: Array<{ id: string; displayName: string }>;
    leaves: Array<{
      id: string;
      unicodeEmoji: string;
      title: string;
      status: string;
      days: Array<{ day: string }>;
      user: {
        id: string;
        displayName: string;
      };
      permitUpdate: boolean;
      permitDestroy: boolean;
      permitApprove: boolean;
    }>;
    nextPageUrl: string | null;
  };
  'leaves/new': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    permitUserSelect: boolean;
    users: Array<{ id: string; displayName: string }>;
  };
  'pages/home': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    upcomingLeaves: Array<{
      id: string;
      startDate: string;
      endDate: string;
      title: string;
    }>;
    payslips: Array<{ id: string; month: string; url: string }>;
    remainingHolidays: number;
    dailyNerdMessage: {
      id: string | null;
      message: string | null;
    } | null;
    needsRetroFor: {
      id: string;
      title: string;
    } | null;
  };
  'payslips/index': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    payslips: Array<{
      id: string;
      user: {
        displayName: string;
      };
      month: string;
      url: string;
      permitDestroy: boolean;
    }>;
    nextPageUrl: string | null;
    permitCreatePayslip: boolean;
  };
  'payslips/new': {
    users: Array<{ id: string; displayName: string }>;
    defaultMonth: string;
  };
  'projects/index': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    projects: Array<{
      id: string;
      name: string;
      clientName: string;
      openInvoiceAmount: number | null;
      openInvoiceCount: number | null;
      lastInvoiced: string | null;
      invoicedRevenue: number | null;
      uninvoicedRevenue: number | null;
      harvestUrl: string | null;
      repository: string | null;
      githubUrl: string | null;
      frameworkVersions: any;
    }>;
    filter: string;
    nextPageUrl: string | null;
  };
  'sessions/edit': { email: string };
  'sessions/new': {};
  'sprint_feedbacks/edit_retro': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    feedback: {
      id: string;
      retroRating: number | null;
      retroText: string | null;
      skipRetro: boolean;
    };
  };
  'sprint_feedbacks/show': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    feedback: {
      id: string;
      finishedStorypoints: number;
      finishedStorypointsPerDay: number;
      retroRating: number | null;
      retroText: string | null;
      workingDayCount: number;
      trackedHours: number;
      billableHours: number;
      turnoverPerStorypoint: number | null;
      turnover: number | null;
      targetTotalHours: number;
      targetBillableHours: number;
      permitEditRetroNotes: boolean;
      sprint: {
        id: string;
        title: string;
        sprintFrom: string;
        sprintUntil: string;
      };
      user: {
        id: string;
        displayName: string;
        email: string;
        avatarUrl: string;
      };
      days: Array<{
        id: string;
        day: string;
        dailyNerdMessage: {
          id: string;
          message: string;
        } | null;
        leave: {
          id: string;
          type: string;
        } | null;
        timeEntries: Array<{
          id: string;
          startAt: string | null;
          endAt: string | null;
          notes: string | null;
          type: string;
          hours: number;
          project: {
            id: string;
            name: string;
          } | null;
          task: {
            id: string;
            status: string;
            totalHours: number;
            repository: string;
            githubUrl: string | null;
            users: Array<{
              id: string;
              displayName: string;
              email: string;
              avatarUrl: string;
            }>;
          } | null;
        }>;
        hasTimeEntries: boolean;
        workingDay: boolean;
        hasDailyNerdMessage: boolean;
        trackedHours: number;
        billableHours: number;
        targetTotalHours: number;
        targetBillableHours: number;
      }>;
    };
  };
  'sprints/index': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    sprints: Array<{
      id: string;
      title: string;
      sprintFrom: string;
      sprintUntil: string;
      finishedStorypoints: number;
      finishedStorypointsPerDay: number;
      averageRating: number;
      totalWorkingDays: number;
      turnoverPerStorypoint: number | null;
      turnover: number | null;
      storypointsPerDepartment: Array<{
        team: string;
        points: number;
        workingDays: number;
        pointsPerWorkingDay: number;
      }>;
      retroNotes: Array<{
        id: string;
        retroText: string | null;
        retroRating: number | null;
        user: {
          id: string;
          displayName: string;
        };
      }>;
      performances: Array<{
        id: string;
        workingDayCount: number;
        trackedHours: number;
        billableHours: number;
        retroRating: number | null;
        finishedStorypoints: number;
        targetTotalHours: number;
        targetBillableHours: number;
        days: Array<{
          id: string;
          day: string;
          workingDay: boolean;
          hasDailyNerdMessage: boolean;
          leave: {
            id: string;
            type: string;
          } | null;
          hasTimeEntries: boolean;
        }>;
        user: {
          id: string;
          displayName: string;
          avatarUrl: string;
        };
      }>;
    }>;
    nextPageUrl: string | null;
    permitCreateSprint: boolean;
  };
  'sprints/new': {
    sprint: {
      sprintFrom: string;
      sprintUntil: string;
      workingDays: number;
    };
  };
  'users/index': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    filter: string;
    users: Array<{
      id: string;
      avatarUrl: string;
      fullName: string;
      nickName: string | null;
      remainingHolidays: number;
      teams: Array<string>;
      currentSalary: {
        brut: number;
        validFrom: string;
      } | null;
    }>;
  };
  'users/show': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
      email: string;
    };
    user: {
      id: string;
      fullName: string;
      remainingHolidays: number;
    };
    salaries: Array<{
      id: string;
      hgfHash: string | null;
      current: boolean;
      validFrom: string;
      brut: number;
      net: number;
    }>;
    inventories: Array<{
      id: string;
      name: string;
      returned: boolean;
      receivedAt: string;
      returnedAt: string | null;
      details: string | null;
    }>;
    permitEditInventory: boolean;
  };
}

export type PageProps<T extends keyof DataSchema> = { data: DataSchema[T] };
