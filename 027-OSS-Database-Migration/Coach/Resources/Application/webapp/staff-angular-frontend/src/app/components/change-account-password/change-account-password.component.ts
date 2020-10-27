import {Component, OnInit} from "@angular/core";
import {AccountService} from "../../services/account.service";
import {ActivatedRoute} from "@angular/router";
import {Location} from "@angular/common";

@Component({
  selector: 'app-change-account-password',
  templateUrl: './change-account-password.component.html',
  styleUrls: ['./change-account-password.component.css']
})
export class ChangeAccountPasswordComponent implements OnInit {

  password: string;
  accountId: number;
  showPassword: boolean = false;

  constructor(private accountService: AccountService,
              private activatedRoute: ActivatedRoute,
              private location: Location) {
  }

  ngOnInit() {
    this.accountId = parseInt(this.activatedRoute.snapshot.paramMap.get('id'));
  }

  onSubmit() {
    this.accountService.changePassword(this.accountId, this.password)
      .subscribe(
        response => {
          this.location.back();
        },
        error => {
          console.error(error);
        }
      );

  }

}
