import React, { Component } from 'react';
import { AzureAD } from 'react-aad-msal';
import { basicReduxStore } from './reduxStore'

// Import the authentication provider which holds the default settings
import { authProvider } from './authProvider';

import './App.css';

import authService from './authService';
import updateUI from './updateUI';
import callPatientSearch from './callPatientSearch';

// Import boostrap-4 components for react
import { Card, Button } from 'bootstrap-4-react';

class App extends Component {
  constructor(props) {
    super(props);

    // Setup react useEffect
    this.state = {
      accountInfo: null,
      sampleType: null,
      bearerToken: '',
      token: '',
      searchValue: '',
      meals: [],
      headers: '',
      resp: ''
    };

    // Bindings necessary to make `this` work in the callback of bound function
    this.handleOnChange = this.handleOnChange.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.handleSearch = this.handleSearch.bind(this);
    this.handleSearchAll = this.handleSearchAll.bind(this);

  }

  // Initialize authService state
  sampleType = localStorage.getItem('sampleType');
  if (sampleType) {
    this.setState({ sampleType });
  }

  // Set authService state to signIn or signOut per Login/Logout button click
  handleClick = sampleType => {
    this.setState({ sampleType });
    localStorage.setItem('sampleType', sampleType);
  };

  // For Patient Search events:
  // Handle search textbox change event - Grab user typed value in textbox
  handleOnChange = (event) => {
      //this.setState({ searchValue: event.target.value });
      console.log('search input:' + event);
  };

  // Handle search form submit event *** NOT USE ***
  handleSubmit(event) {
    alert('A name was submitted: ' + this.state.searchValue);
    authService.searchPatient(this.state.searchValue);
  };

  // Handle Search event
  handleSearch = (search) => {
    this.setState({ searchValue: search });
    console.log('search input:' + this.state.searchValue);
    // Search patient by name
    this.handleClick('search');
    console.log('in search for:' + this.state.searchValue);
  };

   // Handle Search All event
   handleSearchAll = () => {
    // Search all patient
    this.handleClick('searchAll');
  };

// Do search for all patient
seePatients = () => {
    if (authService.msalClient.getAccount()) {

      authService.getTokenPopup(authService.loginRequest)
        .then(response => {
         callPatientSearch(authService.fhirConfig.fhirEndpoint, response.accessToken, "", updateUI);
        }).catch(error => {
          console.log(error);
        });
    }
  };

  // Do search for patient by name
  searchPatient = (searchTxt) => {
    if (authService.msalClient.getAccount()) {
      authService.getTokenPopup(authService.loginRequest)
        .then(response => {
          callPatientSearch(authService.fhirConfig.fhirEndpoint, response.accessToken, searchTxt, updateUI);
        }).catch(error => {
          console.log(error);
        });
    }
  };

  render() {
    // Check state for authentication or search action    
    switch (this.state.sampleType) {
      // Found signIn state
      case 'signIn':
        authService.signIn();
        break;
      // Found signOut state
      case 'signOut':
        authService.signOut();
        break;
      // Found search patient state
      case 'search':
        this.searchPatient(this.state.searchValue);
        break;
      // Found search for all patients state
      case 'searchAll':
        this.seePatients();
        break;
      default:
        break;
    }
    
    return (
      <div className="App">
        <header className="App-header">
          <h1 className="App-title">Welcome to the react-aad-msal sample</h1>
        </header>

        <AzureAD provider={authProvider} reduxStore={basicReduxStore}>
          {({ accountInfo, authenticationState, error }) => {
            return (
              <React.Fragment>      

                <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                  <a class="navbar-brand" href="/">MS Identity Platform</a>
                  <div class="btn-group ml-auto dropleft">
                  <Button onClick={() => this.handleClick('signIn')} className="Button">
                    Sign In
                  </Button>{' '}

                  <Button onClick={() => this.handleClick('signOut')} className="Button">
                    Sign Out
                  </Button>
                  </div>
                </nav>
                <br></br>
                <Card>
                  <Card.Header>
                    <h5 class="card-header text-center">React JavaScript SPA calling FHIR API with MSAL.JS</h5>
                    </Card.Header>
                </Card>
                <br></br>
                <Card>
                  <Card.Body>
                      <Card.Text>
                      <div class="card-body">
                        <div id="main">
                          <h2>Welcome to the patient search app</h2>
                          Enter Given Name: <input type="text" id="searchTxt" name="txt" defaultValue="Jose871" onChange={() => this.handleOnChange(this.value)}></input>

                          <button class="btn btn-primary" id="searchPatient" onClick={() => this.handleSearch(document.getElementById("searchTxt").value)}>Search Patient</button>
                        
                        </div>
                        <br></br>
                        <button class="btn btn-primary" id="seeProfile" onClick={() => this.handleSearchAll()}>See All Patients</button>
                        <br></br>
                        <Card.Title>
                          <h5 class="card-title" id="welcomeMessage">Please sign-in to search for patients</h5>
                        </Card.Title>
                        <div id="profile-div"></div>
                        <br></br>
                      </div>
                      </Card.Text>                    
                  </Card.Body>
                </Card>                  
              </React.Fragment>
            );
          }}
        </AzureAD>
      </div>
    );
  }
}

export default App;
