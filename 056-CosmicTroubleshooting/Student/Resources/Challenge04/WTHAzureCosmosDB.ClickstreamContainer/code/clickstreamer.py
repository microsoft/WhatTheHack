
## Taken and modified from
## https://gist.github.com/jberkus/a4457d40a758f7eca1e8

from typing import Container
import datetime
import random
import time
import sys
import os
import uuid
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from azure.cosmos import CosmosClient

def randuser():
    return (int(random.random() * 100) + 1)

def randpage():
    return (int(random.random() * 100) + 1)

def writeseen( sessinfo, sessnum ):
    ts = datetime.datetime.now()

    container.upsert_item({
        'id': str(uuid.uuid4()),
        'user_id': sessinfo[sessnum]['user'],
        'page_id': sessinfo[sessnum]['page'],
        'date': ts.strftime("%Y-%m-%d")
    })
    
    return True

def randsleep():
    time.sleep(random.random())
    return True

# connect to database
credential = DefaultAzureCredential()
secret_client = SecretClient(vault_url=os.environ['VAULT_URL'], credential=credential)

cosmos_client = CosmosClient(os.environ['ACCOUNT_URI'], credential)

database = cosmos_client.get_database_client(os.environ['COSMOS_DATABASE_NAME'])
container = database.get_container_client(os.environ['COSMOS_CONTAINER_NAME'])

tsession = {}

try:
    # loop forever, or at least until ctrl-c
    while True:
        # loop among four concurrent sessions
        for s in range(1, 4):
            # new session
            if s not in tsession:
                tsession[s] = { "user" : randuser(),
                                "page" : randpage() }
            else:
                pick = random.random()
                if pick < 0.1:
                    # terminate session
                    del tsession[s]
                    continue
                elif pick >= 0.1 and pick < 0.3:
                    # no activity
                    continue
                else:
                    # pick page
                    tsession[s]["page"] = randpage()
            
            writeseen(tsession, s)
            randsleep()
except KeyboardInterrupt:
    print("stream generation halted")
    sys.exit(1)