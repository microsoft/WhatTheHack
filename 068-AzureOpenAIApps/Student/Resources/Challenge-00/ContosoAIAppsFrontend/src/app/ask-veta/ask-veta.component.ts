import { Component } from '@angular/core';
import {OpenAiApiServiceService} from "../service/open-ai-api.service.service";
import {SimpleChatResponse} from "../models/chat-models";

@Component({
  selector: 'app-ask-veta',
  templateUrl: './ask-veta.component.html',
  styleUrls: ['./ask-veta.component.css']
})
export class AskVetaComponent {

  userMessage!: string;
  assistantReply!: string;
  chatMessages: { role: string, content: string }[] = [];

  constructor(private openAiApiService: OpenAiApiServiceService){}

  public sendMessage() {
    const userMessage = this.userMessage;
    this.chatMessages.push({ role: 'user', content: userMessage });
    this.openAiApiService.askVeta<SimpleChatResponse>(this.userMessage)
        .subscribe(response => {
          this.assistantReply = response.reply;
          this.chatMessages.push({ role: 'assistant', content: this.assistantReply });
          this.userMessage = '';
        });
  }
}
