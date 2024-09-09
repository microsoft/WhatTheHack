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
  {path: 'list-assistants', component: ListAssistantsComponent},
  {path: 'ask-donald', component: AskDonaldComponent},
  {path: 'ask-callum', component: AskCallumComponent},
  {path: 'ask-veta', component: AskVetaComponent},
  {path: 'ask-priscilla', component: AskPriscillaComponent},
  {path: 'ask-murphy', component: AskMurphyComponent},
  {path: 'chat-bot', component: ChatbotComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
