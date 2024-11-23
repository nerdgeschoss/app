export interface DataSchema {
  'pages/home': {
    currentUser: {
      id: string;
      email: string;
      firstName: string;
    };
  };
  'users/index': {
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
