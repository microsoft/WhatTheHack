import os
import urllib
import zipfile
from re import sub

import geopandas as gp


def downloadFile(url, saveFolder):
    filename = os.path.basename(url)
    filepath = os.path.join(saveFolder, filename)
    os.makedirs(saveFolder, exist_ok=True)
    print(f"Downloading file from URL: {url} to {filepath}")
    urllib.request.urlretrieve(url, filepath)
    return(filepath)

def unzipFile(zipfilePath, extractPath):
    print(f"Extracting {zipfilePath} to {extractPath}")
    with zipfile.ZipFile(zipfilePath, 'r') as zip_ref:
        zip_ref.extractall(extractPath)
    os.remove(zipfilePath)


def zipdir(path, ziph, base_path):
    for root, dirs, files in os.walk(path):
        for file in files:
            file_path = os.path.join(root, file)
            relative_file_path = os.path.relpath(file_path, base_path)
            if os.path.basename(file_path) != os.path.basename(ziph.filename):
                ziph.write(file_path, relative_file_path)

def toPascalCase(s):
    s = sub(r"(_|-)+", " ", s).title().replace(" ", "").replace("*","")
    return ''.join(s)


outputFolder = "data/"
resourcesZipFilename = f"{outputFolder}resources.zip"

# Zones
rawFilesFolder = f"{outputFolder}Raw/"
bronzeFilesFolder = f"{outputFolder}Bronze/"
silverFilesFolder = f"{outputFolder}Silver/"

os.makedirs(rawFilesFolder, exist_ok=True)
os.makedirs(bronzeFilesFolder, exist_ok=True)
os.makedirs(silverFilesFolder, exist_ok=True)

# WA coastal waters forecast IDW11160.xml amd Marine Forecast Zones IDM000003.zip
bomFtpServer = "ftp://anonymous@ftp.bom.gov.au/"

coastalWatersRawFolder = f"{rawFilesFolder}BOM"
coastalWatersFile = f"{bomFtpServer}anon/gen/fwo/IDW11160.xml"

marineZonesRawFolder = f"{rawFilesFolder}BOM/IDM00003"
marineZonesRawFile = f"{marineZonesRawFolder}/IDM00003.shp"
marineZonesBronzeFile = f"{bronzeFilesFolder}marinezones.geojson"
marineZonesZipFile = f"{bomFtpServer}anon/home/adfd/spatial/IDM00003.zip"

#Shipwrecks (from repo)
shipwrecksRawFolder = f"{rawFilesFolder}WAM"
shipwrecksBronzeFile = f"{bronzeFilesFolder}shipwrecks.geojson"
shipwrecksSilverFile = f"{silverFilesFolder}shipwrecks.json"
shipwrecksFile = "https://raw.githubusercontent.com/liesel-h/WhatTheHack/xxx-FabricLakehouse/067-FabricLakehouse/Coach/Solutions/data/Shipwrecks_WAM_002_WA_GDA94_Public.geojson"


#Download files to Raw
print("Downloading data....")
shipwrecksRawFile = downloadFile(shipwrecksFile, shipwrecksRawFolder)
coastalWatersRawFile = downloadFile(coastalWatersFile, coastalWatersRawFolder)
marineZonesDownloaded   = downloadFile(marineZonesZipFile, marineZonesRawFolder)
unzipFile(marineZonesDownloaded, marineZonesRawFolder)



print("Processing raw files...")
#Read Files
df_shipwrecks = gp.read_file(shipwrecksRawFile)
df_marineZones = gp.read_file(marineZonesRawFile).to_crs(df_shipwrecks.crs) #Normalise CRS of both spatial datasets


#Clean Files, save to Bronze zone
print("Shipwrecks...")
df_shipwrecks.rename(columns=lambda x: toPascalCase(x), inplace=True)
df_shipwrecks.drop(columns={'DateDepth','TimeDepth','MaxDepth','MinDepth','BearingTo','LengthOf','ObjectId','UniqueNum'}, inplace=True)


df_shipwrecks.rename(columns={'TypeOfSi': 'Type', 'DateInspe': 'DateInspected', 'Long':'Lon','CountryBu':'CountryBuilt', 'Constructi': 'Construction','PortRegis':'PortRegisitered', 'FileNumbe': 'FileNumber','OfficialN':'OfficialNumber','Aac': 'AAC'}, inplace=True)
df_shipwrecks.set_geometry("Geometry", inplace=True)
df_shipwrecks.to_file(shipwrecksBronzeFile, driver='GeoJSON') 

print("Marine Zones...")
df_marineZones = df_marineZones[df_marineZones.STATE_CODE == "WA"]
df_marineZones = df_marineZones.where(df_marineZones.notna(), None)
df_marineZones.rename(columns=lambda x: toPascalCase(x), inplace=True)
df_marineZones.rename(columns={'DistName': 'DistrictName'}, inplace=True) 
df_marineZones.drop(columns={'DistNo','StateCode','Type', 'Pt1Name','Pt2Name'}, inplace=True)
df_marineZones.set_geometry("Geometry", inplace=True)
df_marineZones.to_file(marineZonesBronzeFile, driver='GeoJSON')

print("Joining datasets...")
#Spatial Join shipwrecks and marine zones
df_joined = df_shipwrecks.sjoin_nearest(df_marineZones, how="left", distance_col="distance").query("distance < 5000")
#Drop the geometry, it's not supported by parquet
df_joined.drop(columns={'index_right', 'geometry', 'distance'}, inplace=True)
df_joined = df_joined.where(df_joined.notna(), None)
df_joined.to_json(shipwrecksSilverFile, orient='records', lines=True)

print(f"Zipping {resourcesZipFilename}")
resourcesZip = zipfile.ZipFile(resourcesZipFilename, 'w', zipfile.ZIP_DEFLATED)
zipdir(outputFolder, resourcesZip, outputFolder)
resourcesZip.close()