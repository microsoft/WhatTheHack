import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {ChatbotComponent} from "./chatbot/chatbot.component";
import {ListAssistantsComponent} from "./list-assistants/list-assistants.component";
import {AskElizabethComponent} from "./ask-elizabeth/ask-elizabeth.component";
import {AskEstherComponent} from "./ask-esther/ask-esther.component";
import {AskMiriamComponent} from "./ask-miriam/ask-miriam.component";
import {AskPriscillaComponent} from "./ask-priscilla/ask-priscilla.component";
import {AskSarahComponent} from "./ask-sarah/ask-sarah.component";

const routes: Routes = [
  {path: '', component: ListAssistantsComponent, pathMatch: 'full'},
  {path: 'list-assistants', component: ListAssistantsComponent},
  {path: 'ask-elizabeth', component: AskElizabethComponent},
  {path: 'ask-esther', component: AskEstherComponent},
  {path: 'ask-miriam', component: AskMiriamComponent},
  {path: 'ask-priscilla', component: AskPriscillaComponent},
  {path: 'ask-sarah', component: AskSarahComponent},
  {path: 'chat-bot', component: ChatbotComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
