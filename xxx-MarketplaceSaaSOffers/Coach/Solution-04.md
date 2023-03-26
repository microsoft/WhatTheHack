# Challenge 04 - Decoding purchase tokens - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

- navigate to the Emulator Config page
- update the **Langing Page URL** to the solution Landing Page

![Emulator Configuration](Images/emulator_config.png)

- check on the Emulator **Marketplace Token** page that the **Post to landing page** button directs to the solution Landing Page


The challenge updates the file: `src/service/api.ts`

The suggested code is listed below in the section **// -- REMOVE FOR STUDENT -- //**

```
  // -- REMOVE FOR STUDENT -- //

  const resolveUrl = new URL(
    `api/saas/subscriptions/resolve?publisherId=${config.publisherId}&api-version=2018-08-31`,
    config.baseUrl
  );

  console.log('Calling RESOLVE.');

  try {
    const resolveResponse = await fetch(resolveUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-ms-marketplace-token': token,
      },
    });

    if (!resolveResponse.ok) {
      const text = await resolveResponse.text();
      console.log(resolveResponse.status + '-' + text);
      return res.status(400).send(text);
    }

    const resolveResult = await resolveResponse.json();
    console.log(`RESOLVE successful. ${resolveResult}`);

    // -- REMOVE FOR STUDENT -- //
```