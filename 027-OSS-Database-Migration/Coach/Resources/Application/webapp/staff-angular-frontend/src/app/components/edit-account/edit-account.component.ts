import {Component, Input, OnInit} from "@angular/core";
import {ActivatedRoute, Router} from "@angular/router";
import {AccountService} from "../../services/account.service";
import {Location} from "@angular/common";
import {Account} from "../../models/account";
import {Role} from "../../models/role";

@Component({
  selector: 'app-edit-account',
  templateUrl: './edit-account.component.html',
  styleUrls: ['./edit-account.component.css']
})
export class EditAccountComponent implements OnInit {

  @Input()
  account: Account;

  roles: Role[] = Object.keys(Role).map(role => Role[role]);

  constructor(private activatedRoute: ActivatedRoute,
              private accountService: AccountService,
              private location: Location,
              private router: Router) {
  }

  ngOnInit() {
    this.activatedRoute.data.subscribe((data: { account: Account }) => {
      this.account = data.account;
    });
  }

  onSubmit() {
    this.accountService.updateAccount(this.account).subscribe(
      response => {
        this.router.navigate(['accounts']);
      },
      error => {
        console.error(error);
      }
    );

  }

  hasRole(role: Role) {
    return this.account.roles.indexOf(role) > -1;
  }

  onChange(role: Role) {
    const index = this.account.roles.indexOf(role);
    if (index > -1) {
      this.account.roles.splice(index, 1);
    }
    else {
      this.account.roles.push(role);
    }
  }

}
