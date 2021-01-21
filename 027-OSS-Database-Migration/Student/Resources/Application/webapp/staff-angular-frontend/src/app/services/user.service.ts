import {Injectable} from "@angular/core";
import {User} from "../models/user";
import {Observable} from "rxjs";
import {HttpClient, HttpParams} from "@angular/common/http";
import {environment} from "../../environments/environment";
import {Account} from "../models/account";

@Injectable()
export class UserService {

  constructor(private httpClient: HttpClient) {
  }

  getUsers(): Observable<User[]> {
    return this.httpClient.get<User[]>(environment.USERS_RESOURCE_URL);
  }

  getPaginationRange(offset: number, limit: number): Observable<object> {
    let params = new HttpParams()
      .append("offset", offset.toString())
      .append("limit", limit.toString());

    return this.httpClient.get(environment.USERS_RESOURCE_URL, {params: params});
  }

  getUserById(id: number): Observable<User> {
    return this.httpClient.get(environment.USERS_RESOURCE_URL + "/" + id);
  }

  updateUser(user: User): Observable<User> {
    return this.httpClient.put(environment.USERS_RESOURCE_URL, user);
  }

  addUser(user: User, account: Account): Observable<User> {
    return this.httpClient.post(environment.USERS_RESOURCE_URL, {user, account});
  }
}
