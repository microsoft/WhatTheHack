import {Injectable} from "@angular/core";
import {Observable} from "rxjs";
import {Account} from "../models/account";
import {HttpClient, HttpParams} from "@angular/common/http";
import {environment} from "../../environments/environment";

@Injectable()
export class AccountService {

  constructor(private httpClient: HttpClient) { }

  getAccounts(): Observable<Account[]> {
    return this.httpClient.get<Account[]>(environment.ACCOUNTS_RESOURCE_URL);
  }

  getAccountById(id: number): Observable<Account> {
    return this.httpClient.get(environment.ACCOUNTS_RESOURCE_URL + "/" + id);
  }

  updateAccount(account: Account): Observable<Account> {
    return this.httpClient.put(environment.ACCOUNTS_RESOURCE_URL, account);
  }

  changePassword(accountId: number, password: string): Observable<any> {
    return this.httpClient.patch(environment.ACCOUNTS_RESOURCE_URL + "/" + accountId + "/password", password);
  }

  getAccountsInRange(offset: number, limit: number): Observable<object> {
    let params = new HttpParams()
      .append("offset", offset.toString())
      .append("limit", limit.toString());

    return this.httpClient.get(environment.ACCOUNTS_RESOURCE_URL, {params: params});
  }
}
