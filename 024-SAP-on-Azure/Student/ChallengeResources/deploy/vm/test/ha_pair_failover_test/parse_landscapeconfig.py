'''
Format to parse:
   

   | Host     | Host   | Host   | Failover | Remove | Storage   | Storage   | Failover | Failover | NameServer | NameServer | IndexServer | IndexServer | Host   | Host   | Worker  | Worker  |
   |          | Active | Status | Status   | Status | Config    | Actual    | Config   | Actual   | Config     | Actual     | Config      | Actual      | Config | Actual | Config  | Actual  |
   |          |        |        |          |        | Partition | Partition | Group    | Group    | Role       | Role       | Role        | Role        | Roles  | Roles  | Groups  | Groups  |
   | -------- | ------ | ------ | -------- | ------ | --------- | --------- | -------- | -------- | ---------- | ---------- | ----------- | ----------- | ------ | ------ | ------- | ------- |
   | pv1-hdb1 | yes    | ok     |          |        |         1 |         1 | default  | default  | master 1   | master     | worker      | master      | worker | worker | default | default |

'''

import argparse
import json


#Parse SAP Landscape host configuration to get Host Status"
def parseConfig(configFile):
    with open(configFile) as f:
        for line in f:
            if "--------" in line:
                #skip this line and then capture the actual data
                line = next(f)
                host_status = line.split('|')[3]
                print(host_status.strip())


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--file', required=True, help='File containing the landscape host configuration')
    args = parser.parse_args()
    parseConfig(args.file)

if __name__=='__main__':
   main()
