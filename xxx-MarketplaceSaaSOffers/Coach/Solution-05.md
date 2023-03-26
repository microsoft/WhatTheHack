# Challenge 05 - Activate! - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

The challenge updates the file: `src/service/api.ts`

The suggested code is listed below in the section **// -- REMOVE FOR STUDENT -- //**
```
  // -- REMOVE FOR STUDENT -- //

  const activateUrl = new URL(
    `api/saas/subscriptions/${subscription}/activate?publisherId=${config.publisherId}&api-version=2018-08-31`,
    config.baseUrl
  );

  console.log('Calling ACTIVATE.');

  try {
    const activateResponse = await fetch(activateUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ planId: planId }),
    });

    const text = await activateResponse.text();

    if (!activateResponse.ok) {
      console.log(activateResponse.status + '-' + text);
      return res.status(400).send(text);
    }

    console.log(`ACTIVATE successful. ${text}`);

    // -- REMOVE FOR STUDENT -- //
```
