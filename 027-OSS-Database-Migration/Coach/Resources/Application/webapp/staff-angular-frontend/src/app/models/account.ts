import {Role} from "./role";

export interface Account {
  id?: number;
  username?: string;
  password?: string;
  enabled?: boolean;
  accountExpired?: boolean;
  credentialsExpired?: boolean;
  accountLocked?: boolean;
  createdOn?: Date;
  userId?: number;
  roles?: Role[]
}
