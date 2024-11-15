import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ChatbotComponent } from './chatbot/chatbot.component';
import {HttpClientModule} from "@angular/common/http";
import {FormsModule} from "@angular/forms";
import { ListAssistantsComponent } from './list-assistants/list-assistants.component';
import { AskDonaldComponent } from './ask-donald/ask-donald.component';
import { AskCallumComponent } from './ask-callum/ask-callum.component';
import { AskVetaComponent } from './ask-veta/ask-veta.component';
import { AskPriscillaComponent } from './ask-priscilla/ask-priscilla.component';
import { AskMurphyComponent } from './ask-murphy/ask-murphy.component';
import {NgOptimizedImage} from "@angular/common";


@NgModule({
  declarations: [
    AppComponent,
    ChatbotComponent,
    ListAssistantsComponent,
    AskDonaldComponent,
    AskCallumComponent,
    AskVetaComponent,
    AskPriscillaComponent,
    AskMurphyComponent
  ],
    imports: [
        BrowserModule,
        HttpClientModule,
        FormsModule,
        AppRoutingModule,
        NgOptimizedImage
    ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
