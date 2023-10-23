import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {ChatbotComponent} from "./chatbot/chatbot.component";
import {LimoChatbotComponent} from "./limo-chatbot/limo-chatbot.component";

const routes: Routes = [
  {path: '', component: ChatbotComponent, pathMatch: 'full'},
  {path: 'chat-bot', component: ChatbotComponent},
  {path: 'limo-chat', component: LimoChatbotComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
