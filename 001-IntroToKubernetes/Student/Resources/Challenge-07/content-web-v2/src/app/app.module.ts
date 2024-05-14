import { BrowserModule } from '@angular/platform-browser';
import { NgModule, APP_INITIALIZER } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { SpeakersComponent } from './speakers/speakers.component';
import { SessionsComponent } from './sessions/sessions.component';
import { StatsComponent } from './stats/stats.component';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { WINDOW_PROVIDERS } from './window.provider';
import { AppService } from './app.service';

export function initApp(appService: AppService) {
  return () => {
    //appService.getSettings();
  };
}
@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    SpeakersComponent,
    SessionsComponent,
    StatsComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule
  ],
  providers: [WINDOW_PROVIDERS,
    AppService, {
      provide: APP_INITIALIZER,
      useFactory: initApp,
      multi: true,
      deps: [AppService]
    }],
  bootstrap: [AppComponent]
})
export class AppModule {
}
