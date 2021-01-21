import {Injectable} from "@angular/core";
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from "@angular/router";
import {Account} from "../models/account";
import {Observable} from "rxjs";
import {UserService} from "../services/user.service";
import {User} from "../models/user";

@Injectable()
export class UserResolver implements Resolve<Account> {

  constructor(private userService: UserService) {
  }

  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<User> | Promise<User> | User {
    return this.userService.getUserById(parseInt(route.paramMap.get('id'))).pipe();
  }
}
