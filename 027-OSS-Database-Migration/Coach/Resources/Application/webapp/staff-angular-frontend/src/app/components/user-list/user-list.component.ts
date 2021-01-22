import {Component, Input, OnInit} from "@angular/core";
import {UserService} from "../../services/user.service";
import {User} from "../../models/user";

@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.css']
})
export class UserListComponent implements OnInit {

  users: User[];
  p: number = 1;
  loading: boolean;
  total: number;

  @Input()
  usersPerPage: number = 3;

  constructor(private userService: UserService) {

  }

  ngOnInit() {
    this.onPageChange(this.p);
  }

  onPageChange(page: number) {
    this.loading = true;
    const start: number = (page - 1) * this.usersPerPage;
    this.userService.getPaginationRange(start, this.usersPerPage)
      .subscribe(response => {
        this.total = response['totalCount'];
        this.users = response['users'];
        this.p = page;
        this.loading = false;
      });
  }
}
