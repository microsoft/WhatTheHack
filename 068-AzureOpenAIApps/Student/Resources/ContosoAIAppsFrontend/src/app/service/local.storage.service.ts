import {Injectable} from "@angular/core";

@Injectable({
  providedIn: "root",
})
export class LocalStorageService {

  public constructor() {}

  public setItem(key: string, value: string): LocalStorageService {
    localStorage.setItem(key, value)
    return this;
  }

  public getItem(key: string) {
    return localStorage.getItem(key);
  }

  public removeItem(key: string): LocalStorageService {
    localStorage.removeItem(key);
    return this;
  }

  public keyExists(key: string) {
    return localStorage.getItem(key) !== null
  }

  public clearAll(): LocalStorageService {
    localStorage.clear()
    return this;
  }
}
