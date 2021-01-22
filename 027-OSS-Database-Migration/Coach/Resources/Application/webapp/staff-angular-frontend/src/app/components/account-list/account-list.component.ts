import {Component, Input, OnInit} from "@angular/core";
import {AccountService} from "../../services/account.service";
import {Account} from "../../models/account";

@Component({
  selector: 'app-account-list',
  templateUrl: './account-list.component.html',
  styleUrls: ['./account-list.component.css']
})
export class AccountListComponent implements OnInit {

  accounts: Account[];
  p: number = 1;
  loading: boolean;
  total: number;

  @Input()
  accountsPerPage: number = 3;


  constructor(private accountService: AccountService) { }

  ngOnInit() {
    this.onPageChange(this.p);
  }

  onPageChange(page: number) {
    this.loading = true;
    const start: number = (page - 1) * this.accountsPerPage;
    this.accountService.getAccountsInRange(start, this.accountsPerPage)
      .subscribe(response => {
        this.total = response['totalCount'];
        this.accounts = response['accounts'];
        this.p = page;
        this.loading = false;
      });
  }

}
