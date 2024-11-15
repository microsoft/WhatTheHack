import { Component } from '@angular/core';
import {OpenAiApiServiceService} from "../service/open-ai-api.service.service";
import {SimpleChatResponse} from "../models/chat-models";

@Component({
  selector: 'app-ask-murphy',
  templateUrl: './ask-murphy.component.html',
  styleUrls: ['./ask-murphy.component.css']
})
export class AskMurphyComponent {

  userMessage!: string;
  assistantReply!: string;
  chatMessages: { role: string, content: string }[] = [];

  constructor(private openAiApiService: OpenAiApiServiceService){}

  public sendMessage() {
    const userMessage = this.userMessage;
    this.chatMessages.push({ role: 'user', content: userMessage });
    this.openAiApiService.askMurphy<SimpleChatResponse>(this.userMessage)
        .subscribe(response => {
          this.assistantReply = response.reply;
          this.chatMessages.push({ role: 'assistant', content: this.assistantReply });
          this.userMessage = '';
        });
  }
}
