import {Injectable} from "@angular/core";
import {ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot} from "@angular/router";
import {Observable} from "rxjs/Rx";
import {AuthenticationService} from "../services/authentication.service";
import {Role} from "../models/role";

@Injectable()
export class RoleGuard implements CanActivate {

  constructor(private authenticationService: AuthenticationService, private router: Router) {
  }

  canActivate(next: ActivatedRouteSnapshot,
              state: RouterStateSnapshot): Observable<boolean> {
    const roles: Role[] = next.data["roles"];

    return Observable.from(roles)
      .flatMap((role: Role) => this.authenticationService.hasRole(role).catch(error => Observable.of(false)))
      .reduce((acc: boolean, value: boolean) => acc || value)
      .do((hasAnyRoles: boolean) => {
        if (!hasAnyRoles) {
          this.router.navigate(['login', {returnUrl: state.url}]);
        }
      });
  }
}
