import { Component, OnInit } from '@angular/core';
import { SessionsService } from './sessions.service';
import { Session } from '../models/session.model';

@Component({
  selector: 'app-sessions',
  templateUrl: './sessions.component.html',
  styleUrls: ['./sessions.component.css']
})
export class SessionsComponent implements OnInit {
  public sessions: Session[] = [];
  constructor(private sessionsService: SessionsService) { }

  ngOnInit() {
    this.sessionsService.getSessions().subscribe((res: Session[]) => {
      this.sessions = res;
    });
  }

}
