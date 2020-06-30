#!/usr/bin/env python3
# 
#       SMP Downloader
#
#       License:        GNU General Public License (GPL)
#       (c) 2019        Microsoft Corp.
#

import argparse
import re

from helper import *
from SAP_DLM import *
from SAP_Scenarios import *
from SAP_SMP import *

parser = argparse.ArgumentParser(description="Downloader")
parser.add_argument("--config", required=True, type=str, dest="config", help="The configuration file")
parser.add_argument("--dir", required=False, type=str, dest="dir", help="Location to place the download file")
parser.add_argument("--basket", required=False, action="store_true", dest="basket", help="To include item in the basket, default False")
parser.add_argument("--dryrun", required=False, action="store_true", dest="dryrun", help="Dryrun set to True will not actually download the bits")

args = parser.parse_args()
Config.load(args.config)
include_basket = args.basket
dryrun         = args.dryrun
download_dir   = args.dir

# define shortcuts to the configuration files
app = Config.app_scenario
db  = Config.db_scenario
rti = Config.rti_scenario

DLM.init(download_dir, dryrun)
basket = DownloadBasket()

if include_basket:
    DLM.refresh_basket(basket)
    assert(len(basket.items) > 0), \
        "Download basket is empty."
    basket.filter_latest()

SMP.init()
# iterate through all packages
packages = []
if app:
    packages += app.packages
if db:
    packages += db.packages
if rti:
    packages += rti.packages  
for p in packages:
    # Evaluate global condition to decide what software to download
    skip = False
    for c in p.condition:
        if not eval(c):
            skip = True
            break

    if skip:
        continue
    print("Retrieving package %s..." % p.name)

    # iterate through all OS available for package
    for o in p.os_avail:
        relevant_os = eval(p.os_var)
        if type(relevant_os) is str:
            relevant_os = [relevant_os]

        if o not in relevant_os:
            continue
        results = SMP.retrieve(p.retr_params, o)
        cnt     = 0
        while cnt < len(results):
            r = results[cnt]
            assert("Description" in r and "Infotype" in r and "Fastkey" in r and "Filesize" in r and "ReleaseDate" in r), \
                "Result does not have all required keys (%s)" % (str(r))

            r["Filesize"]   = int(r["Filesize"])
            r["ReleaseDate"]  = int(re.search("(\d+)", r["ReleaseDate"]).group(1)) if re.search("(\d+)", r["ReleaseDate"]) else 0

            # Filter out packages that don't match  
            filtered_out = False
            for f in p.filter:
                if not eval(f):
                    results.pop(cnt)
                    filtered_out = True
                    break
            if not filtered_out:
                cnt += 1

        if p.selector: result = results[eval(p.selector)]
        print("%s\n" % (result))
        basket.add_item(DownloadItem(
            id            = result["Fastkey"],
            desc          = result["Description"],
            size          = result["Filesize"],
            time          = basket.latest,
            base_dir      = download_dir,
            target_dir    = p.target_dir,
            skip_download = dryrun,
        ))

if len(basket.items) > 0:
    basket.filter_latest()
    basket.download_all()
