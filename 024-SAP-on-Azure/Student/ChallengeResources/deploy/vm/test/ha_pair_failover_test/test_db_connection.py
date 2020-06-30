import pyhdb
import sys

try:
    connection = pyhdb.connect(host=sys.argv[1],port=sys.argv[2],user=sys.argv[3],password=sys.argv[4])
    cursor = connection.cursor()
    cursor.execute("SELECT HOST AS CURRENT_MASTER, CURRENT_TIME FROM M_CONNECTIONS WHERE CONNECTION_ID = CURRENT_CONNECTION")
    print(cursor.fetchone())
    connection.close()
except:
    print("Connection to the database could not be established. Please check your input and make sure that the database is up and running.")
    exit(1)
