export interface DataSchema {
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
    payslips: Array<{ id: string; month: string }>;
    remainingHolidays: string;
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
}

export type PageProps<T extends keyof DataSchema> = { data: DataSchema[T] };
