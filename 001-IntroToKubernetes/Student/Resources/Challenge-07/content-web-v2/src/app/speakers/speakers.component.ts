import { Component, OnInit } from '@angular/core';
import { Speaker } from '../models/speaker.model';
import { SpeakerService } from './speaker.service';

@Component({
  selector: 'app-speakers',
  templateUrl: './speakers.component.html',
  styleUrls: ['./speakers.component.css']
})
export class SpeakersComponent implements OnInit {
  public speakers: Speaker[] = [];
  constructor(private speakersService: SpeakerService) { }

  ngOnInit() {
    this.speakersService.getSpeakers().subscribe((res: Speaker[]) => {
      this.speakers = res;
    });
  }

}
