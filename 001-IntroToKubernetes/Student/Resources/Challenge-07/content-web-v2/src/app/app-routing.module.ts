import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { SpeakersComponent } from './speakers/speakers.component';
import { SessionsComponent } from './sessions/sessions.component';
import { StatsComponent } from './stats/stats.component';


const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'home', component: HomeComponent },
  { path: 'speakers', component: SpeakersComponent },
  { path: 'sessions', component: SessionsComponent },
  { path: 'stats', component: StatsComponent  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
