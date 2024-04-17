import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ChatbotComponent } from './chatbot/chatbot.component';
import {HttpClientModule} from "@angular/common/http";
import {FormsModule} from "@angular/forms";
import { ListAssistantsComponent } from './list-assistants/list-assistants.component';
import { AskElizabethComponent } from './ask-elizabeth/ask-elizabeth.component';
import { AskEstherComponent } from './ask-esther/ask-esther.component';
import { AskMiriamComponent } from './ask-miriam/ask-miriam.component';
import { AskPriscillaComponent } from './ask-priscilla/ask-priscilla.component';
import { AskSarahComponent } from './ask-sarah/ask-sarah.component';


@NgModule({
  declarations: [
    AppComponent,
    ChatbotComponent,
    ListAssistantsComponent,
    AskElizabethComponent,
    AskEstherComponent,
    AskMiriamComponent,
    AskPriscillaComponent,
    AskSarahComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
