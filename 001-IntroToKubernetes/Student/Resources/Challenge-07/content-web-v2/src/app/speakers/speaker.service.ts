import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { AppService } from '../app.service';

@Injectable({
  providedIn: 'root'
})
export class SpeakerService {

  constructor(private http: HttpClient, private appService: AppService) { }
  public getSpeakers() {
    return this.http.get('/api/speakers');
  }
}
