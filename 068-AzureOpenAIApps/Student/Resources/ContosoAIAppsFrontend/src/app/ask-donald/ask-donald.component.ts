import { Component } from '@angular/core';
import {OpenAiApiServiceService} from "../service/open-ai-api.service.service";
import {SimpleChatResponse} from "../models/chat-models";

@Component({
  selector: 'app-ask-donald',
  templateUrl: './ask-donald.component.html',
  styleUrls: ['./ask-donald.component.css']
})
export class AskDonaldComponent {

  userMessage!: string;
  assistantReply!: string;
  chatMessages: { role: string, content: string }[] = [];

  constructor(private openAiApiService: OpenAiApiServiceService){}

  public sendMessage() {
    const userMessage = this.userMessage;
    this.chatMessages.push({ role: 'user', content: userMessage });
    this.openAiApiService.askDonald<SimpleChatResponse>(this.userMessage)
        .subscribe(response => {
          this.assistantReply = response.reply;
          this.chatMessages.push({ role: 'assistant', content: this.assistantReply });
          this.userMessage = '';
        });
  }
}
