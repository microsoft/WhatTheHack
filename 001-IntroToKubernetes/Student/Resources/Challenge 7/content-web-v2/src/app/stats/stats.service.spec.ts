import { TestBed } from '@angular/core/testing';

import { StatsService } from './stats.service';

describe('StatsService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: StatsService = TestBed.get(StatsService);
    expect(service).toBeTruthy();
  });
});
