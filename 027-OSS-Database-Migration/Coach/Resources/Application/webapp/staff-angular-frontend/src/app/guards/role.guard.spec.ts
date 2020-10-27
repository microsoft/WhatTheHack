import {inject, TestBed} from "@angular/core/testing";

import {RoleGuard} from "./role.guard";

describe('RoleGuard', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [RoleGuard]
    });
  });

  it('should ...', inject([RoleGuard], (guard: RoleGuard) => {
    expect(guard).toBeTruthy();
  }));
});
