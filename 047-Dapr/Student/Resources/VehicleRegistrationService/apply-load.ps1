# This script uses Apache Bench to simulate concurrent load.
# Download the Windows zip for apache (from https://www.apachelounge.com/download/)
# and extract ab.exe form the zip file.

ab -k -l -d -S `
-c 10 `
-n 100 `
http://localhost:3602/v1.0/invoke/vehicleregistrationservice/method/rdw/vehicle/21-KTG-4