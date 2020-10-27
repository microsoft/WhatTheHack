import {Component, OnInit} from "@angular/core";
import {AuthenticationService} from "../../services/authentication.service";
import {ActivatedRoute, Router} from "@angular/router";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  username: string;
  password: string;

  invalidCredentials: boolean;
  communicationError: boolean;

  constructor(private authenticationService: AuthenticationService,
              private router: Router,
              private activatedRoute: ActivatedRoute
  ) { }

  ngOnInit() {
  }

  onSubmit() {
    console.log("submit");
    this.authenticationService.login(this.username, this.password).subscribe(loginSuccessful => {
      if (loginSuccessful) {
        const returnUrl: string = this.activatedRoute.snapshot.paramMap.get('returnUrl') || '/';
        this.router.navigate([returnUrl]);
      }
      else {
        this.invalidCredentials = true;
      }
    },
    error => {
      this.communicationError = true;
    }
    );
  }
}
