/**
 * Encapsulation of the identity of the user.
 */
export default class Identity {
    constructor(tokenResponse) {
      this.account = tokenResponse.account;
      this.rawIdToken = tokenResponse.idToken.rawIdToken;
    }
  
    get userId() {
      return this.account.accountIdentifier;
    }
  
    get emailAddress() {
      return this.account.userName;
    }
  
    get name() {
      return this.account.name;
    }
  
    get idToken() {
      return this.rawIdToken;
    }
  }