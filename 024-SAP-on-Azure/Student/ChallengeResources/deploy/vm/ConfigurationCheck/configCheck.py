import os
import sys,errno

try:
   assert 'ARM_SUBSCRIPTION_ID' in os.environ
   assert 'ARM_TENANT_ID' in os.environ
   assert 'ARM_CLIENT_ID' in os.environ
   assert 'ARM_CLIENT_SECRET' in os.environ
   assert 'AZURE_SUBSCRIPTION_ID' in os.environ
   assert 'AZURE_TENANT' in os.environ
   assert 'AZURE_CLIENT_ID' in os.environ
   assert 'AZURE_SECRET' in os.environ
except:
   print("One or more Azure login credentials are not set correctly. Please set the environment variables as instructed in the README.md")
   sys.exit(errno.EINVAL)
exit(0)

