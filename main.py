# Cannonball Internal API
# IMPORTS
import os
import urllib
import json
from flask import Flask, render_template, request, flash, redirect, url_for, session, logging
from flask_pymongo import PyMongo

# END IMPORTS

# Define App requirements
app = Flask(__name__, static_folder="../static", template_folder="../static")

# CONFIG
app.config["MONGO_URI"] = "mongodb://" + urllib.parse.quote("cannonball") + ":" + urllib.parse.quote("test") + "@cluster0-shard-00-00-pevs9.gcp.mongodb.net:27017,cluster0-shard-00-01-pevs9.gcp.mongodb.net:27017,cluster0-shard-00-02-pevs9.gcp.mongodb.net:27017/CannonballDB?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true"
app.debug=True
mongo = PyMongo(app)

@app.route("/")
def index():
    return("<h1>Cannonball!</h1>")

@app.route("/test", methods=['GET'])
def test():
    mongo.db.users.insert({"user": "patrick"})
    app.logger.debug("Got Request from Flutter")
    return 'Nice! You Triggered it!'


@app.route("/newUser", methods=['POST'])
def insertNewUser():
    newUser = request.get_json()
    app.logger.info(newUser)
    mongo.db.users.insert(newUser)
    return 'user inserted'

@app.route("/newGroup", methods=['POST'])
def insertNewGroup():
    newGroup = request.get_json()
    app.logger.info(newGroup)
    mongo.db.groups.insert(newGroup)
    s = "Created new Group: " + str(newGroup)
    return s

@app.route("/newEvent", methods=['POST'])
def insertNewEvent():
    newEvent = request.get_json()
    app.logger.info(newEvent)
    mongo.db.events.insert(newEvent)
    return 'Created new Event:{}', newEvent

@app.route("/checkInUser", methods=['POST'])
def checkInUser():
    app.logger.info('recieved')
    newCheckIn = request.get_json()
    app.logger.info(newCheckIn)
    event = newCheckIn.get('name')
    targetEvent = mongo.db.events.find_one({'name': event})
    useremail = newCheckIn.get('email')
    targetUser = mongo.db.users.find_one({'email': useremail})
    app.logger.info(targetUser)
    app.logger.info(targetEvent)
    userId = targetUser.get("_id")
    myId = targetEvent.get("_id")
    if myId != None :
        mongo.db.events.update_one({'_id': myId}, {'$push': {'checkedInUsers': userId}})
    return 'placeholder'





@app.route("/createGroup", methods=['GET'])
def buildGroup():
    app.logger.info("Creating new group...")


# LAUNCH APP
if __name__ == "__main__":
        port = int(os.environ.get("PORT", 5000))
        app.logger.info("Getting Flask up and running...\n")
        app.run(host = '127.0.0.1' , port = port)
