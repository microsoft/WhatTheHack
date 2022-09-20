import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { AppService } from '../app.service';

@Injectable({
  providedIn: 'root'
})
export class SessionsService {

  constructor(private http: HttpClient, private appService: AppService) { }
  public getSessions() {
    return this.http.get('/api/sessions');
  }
}
