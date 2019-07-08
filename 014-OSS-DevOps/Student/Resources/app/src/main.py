from flask import Flask, request, render_template
import socket
import sys
import os

app = Flask(__name__)

# Load configurations
app.config.from_pyfile('config_file.cfg')
button1 =       app.config['VOTE1VALUE']  
button2 =       app.config['VOTE2VALUE']
title =         app.config['TITLE']

# Change title to host name to demo NLB
if app.config['SHOWHOST'] == "true":
    title = socket.gethostname()

@app.route('/', methods=['GET', 'POST'])
def index():
    # Vote tracking
    vote1 = 0
    vote2 = 0

    if request.method == 'GET':        
        # Return index with values
        return render_template("index.html", value1=vote1, value2=vote2, button1=button1, button2=button2, title=title)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True, port=80)