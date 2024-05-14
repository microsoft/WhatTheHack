import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Settings } from './models/settings.model';

@Injectable({
  providedIn: 'root'
})
export class AppService {
  public ContentUrl: string;
  constructor(private http: HttpClient) {
  }

  // public getSettings() {
  //   this.http.get('/config/content').subscribe((res: Settings) => {
  //     return this.ContentUrl = res.contentUrl;
  //   });
  // }
}
