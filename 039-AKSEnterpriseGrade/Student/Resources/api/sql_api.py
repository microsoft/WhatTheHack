import os
import socket, struct
import sys
import time
import warnings
import requests
import dns.resolver
import psycopg2
import datetime

from flask import Flask
from flask import request
from flask import jsonify

# If not using SQL APIs, pyodbc and pymysql are not required and could not be installed
# If pyodbc is not correclty imported the Azure SQL DB calls will break
# If pymysql is not correclty imported the Azure SQL DB for MySQL calls will break
try:
    import pyodbc
    import pymysql
except:
    pass

def init_odbc(cx_string):
    cnxn = pyodbc.connect(cx_string)
    return cnxn

def get_sqlversion(cx):
    cursor = cx.cursor()
    cursor.execute('SELECT @@VERSION')
    return cursor.fetchall()

def get_sqlsrcip(cx):
    cursor = cx.cursor()
    cursor.execute('SELECT CONNECTIONPROPERTY("client_net_address")')
    return cursor.fetchall()

def get_sqlquery(cx, query):
    cursor = cx.cursor()
    cursor.execute(query)
    try:
        rows = cursor.fetchall()
        app.logger.info('Query "' + query + '" has returned ' + str(len(rows)) + ' rows')
        app.logger.info('Variable type for first row: ' + str(type(rows[0])))
        if len(rows) > 0:
            return rows[0][0]
        else:
            return None
    except:
        try:
            cursor.commit()
        except:
            pass
        app.logger.info('Query "' + query + '" has returned no rows')
        return None

def get_variable_value(variable_name):
    variable_value = os.environ.get(variable_name)
    basis_path='/secrets'
    variable_path = os.path.join(basis_path, variable_name)
    if variable_value == None and os.path.isfile(variable_path):
        with open(variable_path, 'r') as file:
            variable_value = file.read().replace('\n', '')
    return variable_value

# Return True if IP address is valid
def is_valid_ipv4_address(address):
    try:
        socket.inet_pton(socket.AF_INET, address)
    except AttributeError:  # no inet_pton here, sorry
        try:
            socket.inet_aton(address)
        except socket.error:
            return False
        return address.count('.') == 3
    except socket.error:  # not a valid address
        return False
    return True

# To add to SQL cx to handle output
def handle_sql_variant_as_string(value):
    # return value.decode('utf-16le')
    return value.decode('utf-8')

# Calculates x digits of number pi
def pi_digits(x):
    """Generate x digits of Pi."""
    k,a,b,a1,b1 = 2,4,1,12,4
    while x > 0:
        p,q,k = k * k, 2 * k + 1, k + 1
        a,b,a1,b1 = a1, b1, p*a + q*a1, p*b + q*b1
        d,d1 = a/b, a1/b1
        while d == d1 and x > 0:
            yield int(d)
            x -= 1
            a,a1 = 10*(a % b), 10*(a1 % b1)
            d,d1 = a/b, a1/b1

def send_sql_query(sql_server_fqdn = None, sql_server_db = None, sql_server_username = None, sql_server_password = None, sql_query = None, sql_engine=None, use_ssl=None):
    # Only set the sql_server_fqdn and db variable if not supplied as argument
    if sql_server_fqdn == None:
        sql_server_fqdn = get_variable_value('SQL_SERVER_FQDN')
    if sql_server_db == None:
        sql_server_db = get_variable_value('SQL_SERVER_DB')
    if sql_server_username == None:
        sql_server_username = get_variable_value('SQL_SERVER_USERNAME')
    if sql_server_password == None:
        sql_server_password = get_variable_value('SQL_SERVER_PASSWORD')
    if use_ssl == None:
        use_ssl = get_variable_value('USE_SSL')
        if use_ssl == None:
            use_ssl = 'yes'
    if sql_engine == None:
        sql_engine = get_variable_value('SQL_ENGINE')
        if sql_engine == None:
            sql_engine = 'sqlserver'
    # Check we have the right variables (note that SQL_SERVER_DB is optional)
    if sql_server_username == None or sql_server_password == None or sql_server_fqdn == None:
        print('DEBUG - Required environment variables not present')
        return 'Required environment variables not present: ' + str(sql_server_fqdn) + ' :' + str(sql_server_username) + '/' + str(sql_server_password)    # Build connection string
    if sql_engine == "sqlserver":
        if sql_query == None:
            sql_query = 'SELECT @@VERSION'
        cx_string=''
        drivers = pyodbc.drivers()
        # print('Available ODBC drivers:', drivers)   # DEBUG
        if len(drivers) == 0:
            app.logger.error('Oh oh, it looks like you have no ODBC drivers installed :(')
            return "No ODBC drivers installed"
        else:
            # Take first driver, for our basic stuff any should do
            driver = drivers[0]
            if sql_server_db == None:
                app.logger.info("Building connection string with no Database")
                cx_string = "Driver={{{0}}};Server=tcp:{1},1433;Uid={2};Pwd={3};Encrypt=yes;TrustServerCertificate=yes;Connection Timeut=30;".format(driver, sql_server_fqdn, sql_server_username, sql_server_password)
            else:
                app.logger.info("Building connection string with Database")
                cx_string = "Driver={{{0}}};Server=tcp:{1},1433;Database={2};Uid={3};Pwd={4};Encrypt=yes;TrustServerCertificate=yes;Connection Timeut=30;".format(driver, sql_server_fqdn, sql_server_db, sql_server_username, sql_server_password)
            app.logger.info('connection string: ' + cx_string)
        # Connect to DB
        app.logger.info('Connecting to database server ' + sql_server_fqdn + ' - ' + get_ip(sql_server_fqdn) + '...')
        try:
            cx = init_odbc(cx_string)
            cx.add_output_converter(-150, handle_sql_variant_as_string)
        except Exception as e:
            if is_valid_ipv4_address(sql_server_fqdn):
                error_msg = 'SQL Server FQDN should not be an IP address when targeting Azure SQL Database, maybe this is a problem?'
            else:
                error_msg = 'Connection to server ' + sql_server_fqdn + ' failed, you might have to update the firewall rules or check your credentials?'
            app.logger.info(error_msg)
            app.logger.error(e)
            return error_msg
        # Send SQL query
        app.logger.info('Sending SQL query ' + sql_query + '...')
        try:
            # sql_output = get_sqlversion(cx)
            # sql_output = get_sqlsrcip(cx)
            sql_output = get_sqlquery(cx, sql_query)
            app.logger.info('Closing SQL connection...')
            cx.close()
            return str(sql_output)
        except Exception as e:
            # app.logger.error('Error sending query to the database')
            app.logger.error(e)
            return None
    elif sql_engine == 'mysql':
        if sql_query == None:
            sql_query = "SELECT VERSION();"
        try:
            # Different connection strings if using a database or not, if using SSL or not
            if use_ssl == 'yes':
                if sql_server_db == None:
                    app.logger.info('Connecting with SSL to mysql server ' + str(sql_server_fqdn) + ', username ' + str(sql_server_username) + ', password ' + str(sql_server_password))
                    db = pymysql.connect(host=sql_server_fqdn, user=sql_server_username, passwd=sql_server_password, ssl={'ssl':{'ca': 'BaltimoreCyberTrustRoot.crt.pem'}})
                else:
                    app.logger.info('Connecting with SSL to mysql server ' + str(sql_server_fqdn) + ', database ' + str(sql_server_db) + ', username ' + str(sql_server_username) + ', password ' + str(sql_server_password))
                    db = pymysql.connect(sql_server_fqdn, sql_server_username, sql_server_password, sql_server_db, ssl={'ssl':{'ca': 'BaltimoreCyberTrustRoot.crt.pem'}})
            else:
                if sql_server_db == None:
                    app.logger.info('Connecting without SSL to mysql server ' + str(sql_server_fqdn) + ', username ' + str(sql_server_username) + ', password ' + str(sql_server_password))
                    db = pymysql.connect(host=sql_server_fqdn, user=sql_server_username, passwd=sql_server_password)
                else:
                    app.logger.info('Connecting without SSL to mysql server ' + str(sql_server_fqdn) + ', database ' + str(sql_server_db) + ', username ' + str(sql_server_username) + ', password ' + str(sql_server_password))
                    db = pymysql.connect(sql_server_fqdn, sql_server_username, sql_server_password, sql_server_db)
            # Send query and extract data
            cursor = db.cursor()
            cursor.execute(sql_query)
            # Option 1: first row only
            # data = cursor.fetchone()
            # Option 2: all rows
            rows = cursor.fetchall()
            data = ''
            app.logger.info('Query "' + sql_query + '" has returned ' + str(len(rows)) + ' rows')
            app.logger.info('Variable type for first row: ' + str(type(rows[0])))
            if len(rows) > 0:
                for row in rows:
                    if len(data) > 0:
                        data += ', '
                    data += str(''.join(row))
            else:
                return None
            # Return value
            db.close()
            return str(data)
        except Exception as e:
            error_msg = "Error, something happened when sending a query to a MySQL server"
            app.logger.info(error_msg)
            app.logger.error(e)
            return str(e)
    elif sql_engine == "postgres":
        if sql_query == None:
            sql_query = "SELECT VERSION();"
        # The user must be in the format user@server
        sql_server_name = sql_server_fqdn.split('.')[0]
        if sql_server_name:
            sql_server_username = sql_server_username + '@' + sql_server_name
        else:
            error_msg = "MySql server name could not be retrieved out of FQDN"
            app.logger.info(error_msg)
            return error_msg
        try:
            # Different connection strings if using a database or not
            if sql_server_db == None:
                # conn_string = "host='" + str(sql_server_fqdn) + "' user='" + str(sql_server_username) + "' password='" + str(sql_server_password) + "'"
                conn_string = "host='" + str(sql_server_fqdn) + "' user='" + str(sql_server_username) + "' password='" + str(sql_server_password)+ "' dbname='postgres'"
                app.logger.info('Connecting to Postgres with connection string: ' + conn_string)
            else:
                conn_string = "host='" + str(sql_server_fqdn) + "' user='" + str(sql_server_username) + "' password='" + str(sql_server_password)+ "' dbname='" + str(sql_server_db) + "'"
                app.logger.info('Connecting to Postgres with connection string: ' + conn_string)
            # Send query and extract data
            conn = psycopg2.connect(conn_string)

            cursor = conn.cursor()
            cursor.execute(sql_query)
            data = cursor.fetchone()
            conn.close()
            return str(''.join(data))
        except Exception as e:
            error_msg = "Error, something happened when sending a query to a MySQL server"
            app.logger.info(error_msg)
            app.logger.error(e)
            return str(e)
    else:
        error_msg = 'DB engine ' + sql_engine + ' not supported'
        app.logger.error(error_msg)
        return error_msg

# Get IP for a DNS name
def get_ip(d):
    try:
        return socket.gethostbyname(d)
    except Exception:
        return False

app = Flask(__name__)

# Get IP addresses of DNS servers
def get_dns_ips():
    try:
        dns_ips = []
        with open('/etc/resolv.conf') as fp:
            for cnt, line in enumerate(fp):
                columns = line.split()
                if columns[0] == 'nameserver':
                    ip = columns[1:][0]
                    if is_valid_ipv4_address(ip):
                        dns_ips.append(ip)
        return dns_ips
        my_resolver = dns.resolver.Resolver()
        return str(my_resolver.nameservers)
    except:
        return ''

# Get default gateway
def get_default_gateway():
    """Read the default gateway directly from /proc."""
    try:
        with open("/proc/net/route") as fh:
            for line in fh:
                fields = line.strip().split()
                if fields[1] != '00000000' or not int(fields[3], 16) & 2:
                    continue
                return socket.inet_ntoa(struct.pack("<L", int(fields[2], 16)))
    except Exception as e:
        return str(e)

# Flask route for healthchecks
@app.route("/api/healthcheck", methods=['GET'])
def healthcheck():
    if request.method == 'GET':
        try:
          msg = {
            'health': 'OK',
            'version': '1.0'
          }
          return jsonify(msg)
        except Exception as e:
          return jsonify(str(e))

# Flask route to ping the SQL server with a basic SQL query
@app.route("/api/sql", methods=['GET'])
def sql():
    if request.method == 'GET':
        try:
            sql_server_fqdn = request.args.get('SQL_SERVER_FQDN')   #if key doesn't exist, returns None
            sql_server_db = request.args.get('SQL_SERVER_DB')
            sql_server_username = request.args.get('SQL_SERVER_USERNAME')
            sql_server_password = request.args.get('SQL_SERVER_PASSWORD')
            sql_engine = request.args.get('SQL_ENGINE')
            use_ssl = request.args.get('USE_SSL')
            sql_query = request.args.get('QUERY')
            sql_output = send_sql_query(sql_server_fqdn=sql_server_fqdn, sql_server_db=sql_server_db, sql_server_username=sql_server_username, sql_server_password=sql_server_password, sql_query=sql_query, sql_engine=sql_engine, use_ssl=use_ssl)
            msg = {
                'sql_output': sql_output
            }
            return jsonify(msg)
        except Exception as e:
          return jsonify(str(e))

# Flask route to ping the SQL server with a basic SQL query
@app.route("/api/sqlversion", methods=['GET'])
def sqlversion():
    if request.method == 'GET':
        sql_query = 'SELECT @@VERSION'
        try:
            sql_server_fqdn = request.args.get('SQL_SERVER_FQDN')
            sql_server_db = request.args.get('SQL_SERVER_DB')
            sql_server_username = request.args.get('SQL_SERVER_USERNAME')
            sql_server_password = request.args.get('SQL_SERVER_PASSWORD')
            sql_engine = request.args.get('SQL_ENGINE')
            app.logger.info('Values retrieved from the query: {0}, db {1}: credentials {2}/{3}'.format(str(sql_server_fqdn), str(sql_server_db), str(sql_server_username), str(sql_server_password)))
            # No need to give the query as parameter, "SELECT @@VERSION" is hte default for the function send_sql_query
            sql_output = send_sql_query(sql_server_fqdn=sql_server_fqdn, sql_server_db=sql_server_db, sql_server_username=sql_server_username, sql_server_password=sql_server_password, sql_engine=sql_engine)
            msg = {
            'sql_output': sql_output
            }
            return jsonify(msg)
        except Exception as e:
          return jsonify(str(e))

@app.route("/api/sqlsrcip", methods=['GET'])
def sqlsrcip():
    if request.method == 'GET':
        try:
            sql_server_fqdn = request.args.get('SQL_SERVER_FQDN')
            sql_server_db = request.args.get('SQL_SERVER_DB')
            sql_server_username = request.args.get('SQL_SERVER_USERNAME')
            sql_server_password = request.args.get('SQL_SERVER_PASSWORD')
            use_ssl = request.args.get('USE_SSL')
            if request.args.get('SQL_ENGINE') == None:
                sql_engine = get_variable_value('SQL_ENGINE')
                if sql_engine == None:
                    sql_engine = 'sqlserver'
            else:
                sql_engine = request.args.get('SQL_ENGINE')
            # Select the right query for the src IP depending on the DB engine
            if sql_engine == 'sqlserver':
                sql_query = 'SELECT CONNECTIONPROPERTY(\'client_net_address\')'
            elif sql_engine == 'mysql':
                sql_query = 'SELECT host FROM information_schema.processlist WHERE ID=connection_id();'
            elif sql_engine == 'postgres':
                sql_query = 'SELECT inet_client_addr ();'

            app.logger.info('Values retrieved from the query: {0}, db {1}: credentials {2}/{3}'.format(str(sql_server_fqdn), str(sql_server_db), str(sql_server_username), str(sql_server_password)))
            sql_output = send_sql_query(sql_server_fqdn=sql_server_fqdn, sql_server_db=sql_server_db, sql_server_username=sql_server_username, sql_server_password=sql_server_password, sql_query=sql_query, sql_engine=sql_engine)
            msg = {
            'sql_output': sql_output
            }
            return jsonify(msg)
        except Exception as e:
          return jsonify(str(e))

@app.route("/api/sqlsrcipinit", methods=['GET'])
def sqlsrcipinit():
    if request.method == 'GET':
        try:
            # Get variables from the request
            sql_server_fqdn = request.args.get('SQL_SERVER_FQDN')
            sql_server_db = request.args.get('SQL_SERVER_DB')
            sql_server_username = request.args.get('SQL_SERVER_USERNAME')
            sql_server_password = request.args.get('SQL_SERVER_PASSWORD')
            use_ssl = request.args.get('USE_SSL')
            if request.args.get('SQL_ENGINE') == None:
                sql_engine = get_variable_value('SQL_ENGINE')
                if sql_engine == None:
                    sql_engine = 'sqlserver'
            else:
                sql_engine = request.args.get('SQL_ENGINE')
            # Select the right query for the src IP depending on the DB engine
            if sql_engine == 'sqlserver':
                sql_query = 'CREATE TABLE srciplog (ip varchar(15), timestamp varchar(30));'
            elif sql_engine == 'mysql':
                sql_query = 'CREATE TABLE srciplog (ip varchar(15), timestamp varchar(30));'
            elif sql_engine == 'postgres':
                sql_query = 'CREATE TABLE srciplog (ip varchar(15), timestamp varchar(30));'

            # Send query to retrieve source IP
            app.logger.info('Values retrieved from the query: {0}, db {1}: credentials {2}/{3}'.format(str(sql_server_fqdn), str(sql_server_db), str(sql_server_username), str(sql_server_password)))
            sql_output = send_sql_query(sql_server_fqdn=sql_server_fqdn, sql_server_db=sql_server_db, sql_server_username=sql_server_username, sql_server_password=sql_server_password, sql_query=sql_query, sql_engine=sql_engine)

            msg = {
            'table_created': 'srciplog'
            }
            return jsonify(msg)
        except Exception as e:
          return jsonify(str(e))

@app.route("/api/sqlsrciplog", methods=['GET'])
def sqlsrciplog():
    if request.method == 'GET':
        try:
            # Get variables from the request
            sql_server_fqdn = request.args.get('SQL_SERVER_FQDN')
            sql_server_db = request.args.get('SQL_SERVER_DB')
            sql_server_username = request.args.get('SQL_SERVER_USERNAME')
            sql_server_password = request.args.get('SQL_SERVER_PASSWORD')
            use_ssl = request.args.get('USE_SSL')
            if request.args.get('SQL_ENGINE') == None:
                sql_engine = get_variable_value('SQL_ENGINE')
                if sql_engine == None:
                    sql_engine = 'sqlserver'
            else:
                sql_engine = request.args.get('SQL_ENGINE')

            # Select the right query for the src IP depending on the DB engine
            if sql_engine == 'sqlserver':
                sql_query = 'SELECT CONNECTIONPROPERTY(\'client_net_address\')'
            elif sql_engine == 'mysql':
                sql_query = 'SELECT host FROM information_schema.processlist WHERE ID=connection_id();'
            elif sql_engine == 'postgres':
                sql_query = 'SELECT inet_client_addr ();'
            # Send query to retrieve source IP
            app.logger.info('Values retrieved from the query: {0}, db {1}: credentials {2}/{3}'.format(str(sql_server_fqdn), str(sql_server_db), str(sql_server_username), str(sql_server_password)))
            src_ip_address = str(send_sql_query(sql_server_fqdn=sql_server_fqdn, sql_server_db=sql_server_db, sql_server_username=sql_server_username, sql_server_password=sql_server_password, sql_query=sql_query, sql_engine=sql_engine))

            # Send query to record IP in the srciplog table
            timestamp = str(datetime.datetime.utcnow())
            if sql_engine == 'sqlserver':
                sql_query = "INSERT INTO srciplog (ip, timestamp) VALUES ('{0}', '{1}');".format(src_ip_address, timestamp)
            elif sql_engine == 'mysql':
                sql_query = "INSERT INTO srciplog (ip, timestamp) VALUES ('{0}', '{1}');".format(src_ip_address, timestamp)
            elif sql_engine == 'postgres':
                sql_query = "INSERT INTO srciplog (ip, timestamp) VALUES ('{0}', '{1}');".format(src_ip_address, timestamp)
            # Send query to retrieve source IP
            app.logger.info('Values retrieved from the query: {0}, db {1}: credentials {2}/{3}'.format(str(sql_server_fqdn), str(sql_server_db), str(sql_server_username), str(sql_server_password)))
            sql_output = send_sql_query(sql_server_fqdn=sql_server_fqdn, sql_server_db=sql_server_db, sql_server_username=sql_server_username, sql_server_password=sql_server_password, sql_query=sql_query, sql_engine=sql_engine)

            msg = {
            'srciplog': {
                'ip': src_ip_address,
                'timestamp': timestamp
                }
            }
            return jsonify(msg)
        except Exception as e:
          return jsonify(str(e))

# Flask route to return the number PI
@app.route("/api/pi", methods=['GET'])
def pi():
    try:
        DIGITS = int(request.args.get('digits'))
        if DIGITS == None:
            DIGITS = 10000
        digits = [str(n) for n in list(pi_digits(DIGITS))]
        pi_str = "%s.%s\n" % (digits.pop(0), "".join(digits))
        msg = {
                'pi': pi_str
        }
        return jsonify(msg)
    except Exception as e:
        return jsonify(str(e))

# Flask route to provide the container's IP address
@app.route("/api/dns", methods=['GET'])
def dns():
    try:
        fqdn = request.args.get('fqdn')
        ip = get_ip(fqdn)
        msg = {
                'fqdn': fqdn,
                'ip': ip
        }
        return jsonify(msg)
    except Exception as e:
        return jsonify(str(e))


# Flask route to provide the container's IP address
@app.route("/api/ip", methods=['GET'])
def ip():
    if request.method == 'GET':
        try:
            # url = 'http://ifconfig.co/json'
            url = 'http://jsonip.com'
            mypip_json = requests.get(url).json()
            mypip = mypip_json['ip']
            if request.headers.getlist("X-Forwarded-For"):
                try:
                    forwarded_for = str(request.headers.getlist("X-Forwarded-For"))
                except:
                    forwarded_for = ""
            else:
                forwarded_for = None
            if request.headers.get("Host"):
                try:
                    host_header = str(request.headers.get("Host"))
                except:
                    host_header = ""
            else:
                forwarded_for = None
            sql_server_fqdn = get_variable_value('SQL_SERVER_FQDN')
            sql_server_ip = get_ip(sql_server_fqdn)
            app.logger.info('Getting our private IP address...')
            myip    = str(get_ip(socket.gethostname()))
            app.logger.info('Getting DNS servers IP addresses...')
            dns_ips = str(get_dns_ips())
            app.logger.info('Getting Default Gateway IP address...')
            def_gwy = str(get_default_gateway())
            app.logger.info('Gettting environment variables HTTP_HOST and PATH_INFO...')
            rem_add = str(request.environ.get('REMOTE_ADDR', ''))
            app.logger.info('Gettting environment variable REMOTE_ADDR...')
            path    = str(request.environ['HTTP_HOST']) + str(request.environ['PATH_INFO'])
            app.logger.info('Crafting response message...')
            msg = {
                'my_private_ip': myip,
                'my_public_ip': mypip,
                'my_dns_servers': dns_ips,
                'my_default_gateway': def_gwy,
                'your_address': rem_add,
                'x-forwarded-for': forwarded_for,
                'host': host_header,
                'path_accessed': path,
                'your_platform': str(request.user_agent.platform),
                'your_browser': str(request.user_agent.browser),
                'sql_server_fqdn': str(sql_server_fqdn),
                'sql_server_ip': str(sql_server_ip)
            }
            return jsonify(msg)
        except Exception as e:
            if msg:
                return str(jsonify(str(e))) + str(msg)
            else:
                return str(jsonify(str(e)))

# Flask route to provide the container's environment variables
@app.route("/api/printenv", methods=['GET'])
def printenv():
    if request.method == 'GET':
        try:
            return jsonify(dict(os.environ))
        except Exception as e:
            return jsonify(str(e))

# Flask route to run a HTTP GET to a target URL and return the answer
@app.route("/api/curl", methods=['GET'])
def curl():
    if request.method == 'GET':
        try:
            url = request.args.get('url')
            if url == None:
                url='http://jsonip.com'
            http_answer = requests.get(url).text
            msg = {
                'url': url,
                'method': 'GET',
                'answer': http_answer
            }
            return jsonify(msg)
        except Exception as e:
            return jsonify(str(e))

# Flask route to connect to MySQL
@app.route("/api/mysql", methods=['GET'])
def mysql():
    if request.method == 'GET':
        sql_query = 'SELECT @@VERSION'
        try:
            # Get variables
            mysql_fqdn = request.args.get('SQL_SERVER_FQDN') or get_variable_value('SQL_SERVER_FQDN')
            mysql_user = request.args.get('SQL_SERVER_USERNAME') or get_variable_value('SQL_SERVER)USERNAME')
            mysql_pswd = request.args.get('SQL_SERVER_PASSWORD') or get_variable_value('SQL_SERVER_PASSWORD')
            mysql_db = request.args.get('SQL_SERVER_DB') or get_variable_value('SQL_SERVER_DB')
            app.logger.info('Values to connect to MySQL:')
            app.logger.info(mysql_fqdn)
            app.logger.info(mysql_db)
            app.logger.info(mysql_user)
            app.logger.info(mysql_pswd)
            # The user must be in the format user@server
            mysql_name = mysql_fqdn.split('.')[0]
            if mysql_name:
                mysql_user = mysql_user + '@' + mysql_name
            else:
                return "MySql server name could not be retrieved out of FQDN"
            # Different connection strings if using a database or not
            if mysql_db == None:
                app.logger.info('Connecting to mysql server ' + str(mysql_fqdn) + ', username ' + str(mysql_user) + ', password ' + str(mysql_pswd))
                db = pymysql.connect(mysql_fqdn, mysql_user, mysql_pswd)
            else:
                app.logger.info('Connecting to mysql server ' + str(mysql_fqdn) + ', database ' + str(mysql_db) + ', username ' + str(mysql_user) + ', password ' + str(mysql_pswd))
                db = pymysql.connect(mysql_fqdn, mysql_user, mysql_pswd, mysql_db)
            # Send query and extract data
            cursor = db.cursor()
            cursor.execute("SELECT VERSION()")
            data = cursor.fetchone()
            app.logger.info('Closing SQL connection...')
            db.close()
            msg = {
                'sql_output': str(data)
            }
            return jsonify(msg)
        except Exception as e:
            return jsonify(str(e))

# Gets the web port out of an environment variable, or defaults to 8080
def get_web_port():
    web_port=os.environ.get('PORT')
    if web_port==None or not web_port.isnumeric():
        print("Using default port 8080")
        web_port=8080
    else:
        print("Port supplied as environment variable:", web_port)
    return web_port

# Ignore warnings
with warnings.catch_warnings():
    warnings.simplefilter("ignore")

# Set web port
web_port=get_web_port()

app.run(host='0.0.0.0', port=web_port, debug=True, use_reloader=False)
