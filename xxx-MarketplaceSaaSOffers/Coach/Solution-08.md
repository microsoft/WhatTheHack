# Challenge 08 - Listening on a webhook - Coach's Guide 

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-09.md)

## Notes & Guidance


The challenge updates the file: `src/service/webhook-api.ts`

The suggested code is listed below in the section **// -- REMOVE FOR STUDENT -- //**

```
// -- REMOVE FOR STUDENT -- //

const action = req.body.action as string;
const planId = req.body.planId as string;
const tenantId = req.body.beneficiary.tenantId as string

switch(action.toLowerCase()) {
    case "changeplan":
    case "changequantity":
        res.sendStatus(200).send();
        await saveEntitlement(tenantId, planId, true);
        return;

    case "reinstate":
        await saveEntitlement(tenantId, planId, true);
        break;
    case "renew":
        break;
    case "suspend":
        await saveEntitlement(tenantId, planId, false);
        break;
    case "unsubscribe":
        await removeEntitlement(tenantId);
        break;
}

// -- REMOVE FOR STUDENT -- //
```
