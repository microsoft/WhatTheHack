import { Component, OnInit, Inject } from '@angular/core';
import { StatsService } from './stats.service';
import { Stat } from '../models/stats.model';
import { WINDOW } from '../window.provider';

@Component({
  selector: 'app-stats',
  templateUrl: './stats.component.html',
  styleUrls: ['./stats.component.css']
})
export class StatsComponent implements OnInit {
  public stats: Stat;
  constructor(private statsService: StatsService, @Inject(WINDOW) private window: Window) { }

  ngOnInit() {
    this.statsService.getStats().subscribe((res: Stat) => {
      this.stats = res;
    });
  }
}
