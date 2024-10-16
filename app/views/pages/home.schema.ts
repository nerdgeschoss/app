export interface Props {
  currentUser: {
    id: string;
    firstName: string;
  };
  sprint: {
    id: string;
    title: string;
  } | null;
}
