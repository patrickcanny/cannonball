# Cannonball Internal API
# IMPORTS
import os
import urllib
import json
from bson import Binary, Code
from bson.json_util import dumps
from flask import Flask, render_template, request, flash, redirect, url_for, session, logging, jsonify
from flask_pymongo import PyMongo
# END IMPORTS

# HERE API
here_appId = "yDIiTl1dh0pFhmMq7Ggf"
here_appCode = "Lz4ozsXQflfSlfcFpG74jw"
here_baseURL = "https://pos.api.here.com/positioning/v1/"
# END HERE

# Define App requirements
app = Flask(__name__, static_folder="../static", template_folder="../static")

# CONFIG
app.config["MONGO_URI"] = "mongodb://" + urllib.parse.quote("cannonball") + ":" + urllib.parse.quote("test") + "@cluster0-shard-00-00-pevs9.gcp.mongodb.net:27017,cluster0-shard-00-01-pevs9.gcp.mongodb.net:27017,cluster0-shard-00-02-pevs9.gcp.mongodb.net:27017/CannonballDB?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true"
app.debug=True
mongo = PyMongo(app)

@app.route("/")
def index():
    return("<h1>Cannonball!</h1>")

@app.route("/getEvents", methods=['GET'])
def events():
    events = mongo.db.events.find()
    app.logger.info(events)
    return dumps(events)

# {{URL}}/getUsersForEvent?event={event name}
@app.route("/getUsersForEvent", methods = ['GET'])
def usersByEvent():
    eventName = request.args.get('name')
    app.logger.info(eventName)
    event = mongo.db.events.find_one({'name': eventName})
    app.logger.info(event)
    users = event.get('checkedInUsers')
    app.logger.info(users)

    userDict = {}
    i = 0
    for user in users:
        uid = user.get('_id')
        elt = mongo.db.users.find_one({"_id": uid})
        userdict[i] = elt
        i += 1
    app.logger.info("UserDict: ", userDict)
    return dumps(userDict)

@app.route("/newUser", methods=['POST'])
def insertNewUser():
    newUser = request.get_json()
    app.logger.info(newUser)
    mongo.db.users.insert(newUser)
    return dumps(newUser)

@app.route("/newGroup", methods=['POST'])
def insertNewGroup():
    newGroup = request.get_json()
    app.logger.info(newGroup)
    mongo.db.groups.insert(newGroup)
    return dumps(newGroup)

@app.route("/newEvent", methods=['POST'])
def insertNewEvent():
    newEvent = request.get_json()
    app.logger.info(newEvent)
    mongo.db.events.insert(newEvent)
    return dumps(newEvent)

@app.route("/checkInUser", methods=['GET'])
def checkInUser():
    json_string = request.args.to_dict()
    parsed_json = json.loads(json_string)
    userkey = parsed_json['userkey']
    groupkey = parsed_json['groupkey']
    return 'placeholder'

@app.route("/goLive", methods=['GET'])
def goLive():
    json_string = request.args.to_dict()
    parsed_json = json.loads(json_string)
    groupkey = parsed_json['groupkey']
    targetGroup = mongo.db.groups.find( {key == groupkey})
    if targetGroup == None:
        return 'no groups found'
    else:
        radius = parsed_json['radius']
        lat = parsed_json['latitude']
        longi = parsed_json['longitude']
        # mongo.db.collection.updateOne({key == groupkey}, $set: {'live': True}, False)
        return 'updated group'

# LAUNCH APP
if __name__ == "__main__":
        port = int(os.environ.get("PORT", 5000))
        app.logger.info("Getting Flask up and running...\n")
        app.run(host = '127.0.0.1' , port = port)
