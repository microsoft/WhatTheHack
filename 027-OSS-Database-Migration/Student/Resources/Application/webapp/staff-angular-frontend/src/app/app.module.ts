import {BrowserModule} from "@angular/platform-browser";
import {NgModule} from "@angular/core";

import {AppComponent} from "./app.component";
import {NavbarComponent} from "./components/navbar/navbar.component";
import {FooterComponent} from "./components/footer/footer.component";
import {UserListComponent} from "./components/user-list/user-list.component";
import {AddUserComponent} from "./components/add-user/add-user.component";
import {EditUserComponent} from "./components/edit-user/edit-user.component";
import {UserService} from "./services/user.service";
import {AccountListComponent} from "./components/account-list/account-list.component";
import {AccountService} from "./services/account.service";
import {AppRoutingModule} from "./app-routing.module";
import {DashboardComponent} from "./components/dashboard/dashboard.component";
import {EditAccountComponent} from "./components/edit-account/edit-account.component";
import {FormsModule} from "@angular/forms";
import {ChangeAccountPasswordComponent} from "./components/change-account-password/change-account-password.component";
import {NgxPaginationModule} from "ngx-pagination";
import {AccountResolver} from "./guards/account-resolver";
import {UserResolver} from "./guards/user-resolver";
import {LoginComponent} from "./components/login/login.component";
import {AuthenticationService} from "./services/authentication.service";
import {HTTP_INTERCEPTORS, HttpClientModule} from "@angular/common/http";
import {RoleGuard} from "./guards/role.guard";
import {XhrInterceptor} from "./interceptors/xhr.interceptor";
import {HttpXsrfInterceptor} from "./interceptors/http-xsrf.interceptor";

@NgModule({
  declarations: [
    AppComponent,
    NavbarComponent,
    FooterComponent,
    UserListComponent,
    AddUserComponent,
    EditUserComponent,
    AccountListComponent,
    DashboardComponent,
    EditAccountComponent,
    ChangeAccountPasswordComponent,
    LoginComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    NgxPaginationModule,
    HttpClientModule
  ],
  providers: [
    UserService,
    AccountService,
    AuthenticationService,
    AccountResolver,
    UserResolver,
    RoleGuard,
    { provide: HTTP_INTERCEPTORS, useClass: XhrInterceptor, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: HttpXsrfInterceptor, multi: true }
  ],
  bootstrap: [AppComponent]
})
export class AppModule {
}
