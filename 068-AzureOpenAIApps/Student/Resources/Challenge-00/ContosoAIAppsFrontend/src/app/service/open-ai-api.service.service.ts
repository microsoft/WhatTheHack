import { Injectable } from '@angular/core';
import {ENVIRONMENT} from "../../environments/environment";
import {HttpClient} from "@angular/common/http";

@Injectable({
  providedIn: 'root'
})
export class OpenAiApiServiceService {

  private apiUrl = ENVIRONMENT.apiUrl; // Update with your Node.js server URL
  constructor(private http: HttpClient) { }

  public sendChatbotMessage<T>(message: string) {

    const clientMessage = {message};

    return this.http.post<T>(`${this.apiUrl}/api/contoso-tourists-basic`, clientMessage);
  }

  public sendLimoChatbotMessage<T>(message: string) {

    const clientMessage = {message};

    return this.http.post<T>(`${this.apiUrl}/api/contoso-limos-chatbot`, clientMessage);
  }
}
