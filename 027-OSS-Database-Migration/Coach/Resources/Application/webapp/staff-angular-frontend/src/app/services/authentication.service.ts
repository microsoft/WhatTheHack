import {Injectable} from "@angular/core";
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {Role} from "../models/role";
import {Observable} from "rxjs/Observable";
import {catchError, map} from "rxjs/operators";
import {environment} from "../../environments/environment";

@Injectable()
export class AuthenticationService {

  username: string = "";
  password: string = "";

  rolePrefix: string = "ROLE_";

  authenticated: boolean = false;

  constructor(private httpClient: HttpClient) {
    this.httpClient.get(environment.AUTHENTICATION_URL, {}).subscribe(
      response => this.authenticated = true,
      error => this.authenticated = false
    );
  }

  login(username: string, password: string): Observable<boolean>  {
    this.username = username;
    this.password = password;
    const headers = new HttpHeaders({
      authorization : 'Basic ' + btoa(username + ':' + password)
    });
    return this.httpClient.get(environment.AUTHENTICATION_URL, {headers: headers})
      .pipe(
        map(response => true),
        catchError(error => Observable.of(false))
      )
      .do(result => this.authenticated = result);
  }

  logout(): void {
    this.httpClient.post(environment.LOGOUT_URL, {}).subscribe(
      response => this.authenticated = false
    );
  }

  hasRole(role: Role): Observable<boolean> {
    return this.httpClient.get(environment.AUTHENTICATION_URL, {}).pipe(
      map(response => response['roles'].indexOf(this.rolePrefix + role) > -1)
    );
  }

  isAuthenticated(): boolean {
    return this.authenticated;
  }


}
