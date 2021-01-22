import {Component, Input, OnInit} from "@angular/core";
import {User} from "../../models/user";
import {UserService} from "../../services/user.service";
import {Account} from "../../models/account";
import {Role} from "../../models/role";
import {Router} from "@angular/router";

@Component({
  selector: 'app-add-user',
  templateUrl: './add-user.component.html',
  styleUrls: ['./add-user.component.css']
})
export class AddUserComponent implements OnInit {

  @Input()
  submitButtonName: string = "Create";

  @Input()
  user: User = {};

  @Input()
  createAccount: boolean = true;

  @Input()
  account: Account = {
    enabled: true,
    roles: []
  };

  roles: Role[] = Object.keys(Role).map(role => Role[role]);

  showPassword: boolean = false;

  constructor(private userService: UserService, private router: Router) { }

  ngOnInit() {
  }

  onSubmit() {
    this.userService.addUser(this.user, this.createAccount ? this.account : undefined)
      .subscribe(
        response => {
          this.router.navigate(["users"]);
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
