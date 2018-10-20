# Cannonball Internal API
# IMPORTS
import os
import urllib
from flask import Flask, render_template, request, flash, redirect, url_for, session, logging
from flask_pymongo import PyMongo

# END IMPORTS

# Define App requirements
app = Flask(__name__, static_folder="../static", template_folder="../static")

# CONFIG
app.config["MONGO_URI"] = "mongodb://" + urllib.parse.quote("marshingjay@ku.edu") + ":" + urllib.parse.quote("Sportingbv#9") + "@cluster0-shard-00-00-pevs9.gcp.mongodb.net:27017,cluster0-shard-00-01-pevs9.gcp.mongodb.net:27017,cluster0-shard-00-02-pevs9.gcp.mongodb.net:27017/test?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true"
app.debug=True
mongo = PyMongo(app)

@app.route("/test", methods=['GET'])
def test():
    mongo.db.users.insert({"name": "jacob" })
    app.logger.debug("Got Request from Flutter")
    return 'Nice! You Triggered it!'

# LAUNCH APP
if __name__ == "__main__":
        port = int(os.environ.get("PORT", 5000))
        app.logger.info("Getting Flask up and running...\n")
        app.run(host = '0.0.0.0' , port = port)
