import {NgModule} from "@angular/core";
import {RouterModule, Routes} from "@angular/router";
import {UserListComponent} from "./components/user-list/user-list.component";
import {AccountListComponent} from "./components/account-list/account-list.component";
import {EditUserComponent} from "./components/edit-user/edit-user.component";
import {DashboardComponent} from "./components/dashboard/dashboard.component";
import {EditAccountComponent} from "./components/edit-account/edit-account.component";
import {AddUserComponent} from "./components/add-user/add-user.component";
import {ChangeAccountPasswordComponent} from "./components/change-account-password/change-account-password.component";
import {AccountResolver} from "./guards/account-resolver";
import {UserResolver} from "./guards/user-resolver";
import {LoginComponent} from "./components/login/login.component";
import {RoleGuard} from "./guards/role.guard";
import {Role} from "./models/role";

const routes: Routes = [
  {path: '', redirectTo: '/dashboard', pathMatch: 'full'},
  {path: "dashboard", component: DashboardComponent, canActivate: [RoleGuard], data: {roles: [Role.ADMIN]}},
  {path: 'users', component: UserListComponent, canActivate: [RoleGuard], data: {roles: [Role.ADMIN]}},
  {path: 'accounts', component: AccountListComponent, canActivate: [RoleGuard], data: {roles: [Role.ADMIN]}},
  {path: 'users/new', component: AddUserComponent, canActivate: [RoleGuard], data: {roles: [Role.ADMIN]}},
  {path: 'users/:id', component: EditUserComponent, resolve: {user: UserResolver}, canActivate: [RoleGuard], data: {roles: [Role.ADMIN]}},
  {path: 'accounts/:id', component: EditAccountComponent, resolve: {account: AccountResolver}, canActivate: [RoleGuard], data: {roles: [Role.ADMIN]}},
  {path: 'accounts/:id/changePassword', component: ChangeAccountPasswordComponent, canActivate: [RoleGuard], data: {roles: [Role.ADMIN]}},
  {path: 'login', component: LoginComponent}
];

@NgModule({
  exports: [
    RouterModule
  ],
  imports: [
    RouterModule.forRoot(routes, {useHash: true})
  ]
})
export class AppRoutingModule {
}
