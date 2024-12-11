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
    permitUserSelect: string;
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
      permitUpdate: string;
      permitDestroy: string;
    }>;
    nextPageUrl: string;
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
