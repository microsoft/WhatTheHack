import { TestBed } from '@angular/core/testing';

import { SessionsService } from './sessions.service';

describe('SessionsService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: SessionsService = TestBed.get(SessionsService);
    expect(service).toBeTruthy();
  });
});
