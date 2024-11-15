import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {ChatbotComponent} from "./chatbot/chatbot.component";
import {ListAssistantsComponent} from "./list-assistants/list-assistants.component";
import {AskDonaldComponent} from "./ask-donald/ask-donald.component";
import {AskCallumComponent} from "./ask-callum/ask-callum.component";
import {AskVetaComponent} from "./ask-veta/ask-veta.component";
import {AskPriscillaComponent} from "./ask-priscilla/ask-priscilla.component";
import {AskMurphyComponent} from "./ask-murphy/ask-murphy.component";

const routes: Routes = [
  {path: '', component: ListAssistantsComponent, pathMatch: 'full'},
  {path: 'list-assistants', component: ListAssistantsComponent, title: "List Assistants"},
  {path: 'ask-donald', component: AskDonaldComponent, title: "Ask Donald"},
  {path: 'ask-callum', component: AskCallumComponent, title: "Ask Callum"},
  {path: 'ask-veta', component: AskVetaComponent, title: "Ask Veta"},
  {path: 'ask-priscilla', component: AskPriscillaComponent, title: "Ask Priscilla"},
  {path: 'ask-murphy', component: AskMurphyComponent, title: "Ask Murphy"},
  {path: 'chat-bot', component: ChatbotComponent, title: "Chat "},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
