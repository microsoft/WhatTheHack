import {Injectable} from "@angular/core";
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from "@angular/router";
import {Account} from "../models/account";
import {AccountService} from "../services/account.service";
import {Observable} from "rxjs";

@Injectable()
export class AccountResolver implements Resolve<Account> {

  constructor(private accountService: AccountService) {
  }

  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<Account> | Promise<Account> | Account {
    return this.accountService.getAccountById(parseInt(route.paramMap.get('id'))).pipe();
  }
}
