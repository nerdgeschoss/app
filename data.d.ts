export interface DataSchema {
  'components/_current_user': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
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
    };
    permitUserSelect: boolean;
    users: Array<{ id: string; displayName: string }>;
  };
  'pages/home': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
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
    nextPageUrl: string;
    permitCreatePayslip: boolean;
  };
  'payslips/new': {
    users: Array<{ id: string; displayName: string }>;
    defaultMonth: string;
  };
  'sessions/edit': { email: string };
  'sessions/new': {};
  'sprint_feedbacks/edit_retro': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
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
          notes: string | null;
          type: string;
          hours: string;
          project: {
            id: string;
            name: string;
          } | null;
          task: {
            id: string;
            status: string;
            totalHours: string;
          } | null;
        }>;
      }>;
    };
  };
  'sprints/index': {
    currentUser: {
      id: string;
      displayName: string;
      avatarUrl: string;
    };
    sprints: Array<{
      id: string;
      title: string;
      sprintFrom: string;
      sprintUntil: string;
      performances: Array<{
        id: string;
        workingDayCount: number;
        trackedHours: number;
        billableHours: number;
        retroRating: number | null;
        finishedStorypoints: number;
        days: Array<{
          id: string;
          day: string;
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
    };
    filter: string;
    users: Array<{
      id: string;
      avatarUrl: string;
      fullName: string;
      nickName: string | null;
      remainingHolidays: number;
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
