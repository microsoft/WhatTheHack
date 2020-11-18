# Coach's Guide: Challenge 6 - Add patient lookup function to the JavaScript app

[< Previous Challenge](./Solution05.md) - **[Home](./readme.md)**

## Notes & Guidance

In this challenge, you will extend the previously deployed sample JavaScript app to add patient lookup.

**Modify sample JavaScript app to add a patient lookup function.**
- Update your JavaScript app to include a patient Lookup feature in App Service Editor.
  - For example, Search patient by Given name
    - Add a Search textbox and button to JavaScript app
    - Add a new search function to call FHIR Server with the following service endpoint:
      `GET {{fhirurl}}/Patient?given:contains=[pass-your-search-text]`
    - Set the 'onclick' event of Search button to call the search function

  Note: App Service Editor will auto save your code changes.

- (Optional) Include any other modern UI features to improve the user experience.
- Test updated sample JavaScript app with patient Lookup feature
  - Browse to App Service website URL in In-private mode
  - Sign in with your secondary tenant used in deploying FHIR Server Samples reference architecture
  - You should see a list of patients that were loaded into FHIR Server
  - Enter full or partial Given name in the Search box and click Search button
    - This will filter patient data that contains the specified Given name and return search results to browser
 