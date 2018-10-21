# Cannonball Internal API
# IMPORTS
import os
import urllib
import json
import math
from bson import Binary, Code
from bson.json_util import dumps, loads
from bson.objectid import ObjectId
from flask import Flask, render_template, request, flash, redirect, url_for, session, logging, jsonify
from flask_pymongo import PyMongo
from slackclient import SlackClient
from dotenv import load_dotenv
# END IMPORTS

APP_ROOT = os.path.join(os.path.dirname(__file__),'..')
dotenv_path = os.path.join(APP_ROOT, '.env')
load_dotenv(dotenv_path)
# Define App requirements
app = Flask(__name__, static_folder="../static", template_folder="../static")

# CONFIG
app.config["MONGO_URI"] = "mongodb://" + urllib.parse.quote("cannonball") + ":" + urllib.parse.quote("test") + "@cluster0-shard-00-00-pevs9.gcp.mongodb.net:27017,cluster0-shard-00-01-pevs9.gcp.mongodb.net:27017,cluster0-shard-00-02-pevs9.gcp.mongodb.net:27017/CannonballDB?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true"
app.debug=True
mongo = PyMongo(app)

token = mongo.db.users.find_one({"slack":{"$exists":True}})
tok = token['slack']
LOGGER = app.logger
LOGGER.info(tok)

# SLACK API
try:
    slack_client = SlackClient(os.getenv('SLACK_KEY'))
except:
    slack_client = SlackClient(tok)



'''@params'''
@app.route("/")
def index():
    return("<h1>Cannonball!</h1>")

'''
@params
f_name: string
l_name: string
email: string
'''
@app.route("/authenticateUser", methods=['POST'])
def authenticate():
    userInfo = request.get_json()
    f_name = userInfo.get('f_name')
    l_name = userInfo.get('l_name')
    email = userInfo.get('email')

    try:
        user = mongo.db.users.find_one({'f_name':f_name},{'l_name':l_name, 'email':email})
        LOGGER.info("Found User {}".format(user))
        return dumps(user)
    except:
        return {}

'''
@params
'''
@app.route("/getEvents", methods=['GET'])
def events():
    events = mongo.db.events.find({"active": True})
    LOGGER.info(events)
    return dumps(events)

'''
@params
name: string as query param described below
'''
# {{URL}}/getUsersForEvent?name={event name}
@app.route("/getUsersForEvent", methods = ['GET'])
def usersByEvent():
    eventName = request.args.get('name')
    LOGGER.info(eventName)
    event = mongo.db.events.find_one({'name': eventName})
    LOGGER.info(event)
    users = event.get('checkedInUsers')
    LOGGER.info(users)

    userDict = {}
    i = 0
    for uid in users:
        elt = mongo.db.users.find_one({"_id": uid})
        userDict[i] = elt
        i += 1
    return dumps(userDict)

'''
@params
newUser: user-formatted JSON as body
see 'data_model/user.json for details'
'''
@app.route("/newUser", methods=['POST'])
def insertNewUser():
    try:
        newUser = request.get_json()
        LOGGER.info(newUser)
        mongo.db.users.insert(newUser)
        return dumps(newUser)
    except:
        return "there was an error in creating a new user: {}".format(newUser)

'''
@params
newGroup: group-formatted JSON as body

'''
@app.route("/newGroup", methods=['POST'])
def insertNewGroup():
    newGroup = request.get_json()
    LOGGER.debug(newGroup)
    newusers = []
    newadmins = []
    for user in newGroup.get('users'):
        uid = str(user['$oid'])
        obj = ObjectId(uid)
        newusers.append(obj)

    for user in newGroup.get('admins'):
        uid = str(user['$oid'])
        obj = ObjectId(uid)
        newadmins.append(obj)

    email = newGroup.get('creator')
    newcreator = email

    LOGGER.debug(newusers)
    newGroup['users'] = newusers
    newGroup['admins'] = newadmins
    newGroup['creator'] = newcreator
    LOGGER.info(newGroup)
    mongo.db.groups.insert(newGroup)
    return dumps(newGroup)

'''
@params
Event-formatted JSON
'''
@app.route("/newEvent", methods=['POST'])
def insertNewEvent():
    newEvent = request.get_json()
    name = newEvent.get('name')
    LOGGER.info(newEvent)
    gid = str(newEvent.get('groupid')['$oid'])
    LOGGER.info(gid)
    newEvent['groupid'] = ObjectId(gid)
    LOGGER.info(newEvent)
    mongo.db.events.insert(newEvent)
    try:
        event = mongo.db.events.find_one({'name': name})
        eid = event.get('_id')
    except:
        return "Could not find newly created event. Perhaps your group does not exist"
    try:
        group = mongo.db.groups.find_one({'_id': ObjectId(gid)})
    except:
        return "Group not found, please create a new group first."
    groupEvents = group.get('events')
    if eid not in groupEvents:
        mongo.db.groups.update_one({'_id': ObjectId(gid)},{'$push':{'events':eid}})
    newEvent.update_one({''})
    return dumps(newEvent)

'''
@params
name: the name of an event
email: some user email that is checking in
'''
@app.route("/checkInUser", methods=['POST'])
def checkInUser():
    LOGGER.info('recieved')
    newCheckIn = request.get_json()
    LOGGER.info(newCheckIn)
    event = newCheckIn.get('name')
    targetEvent = mongo.db.events.find_one({'name': event})
    useremail = newCheckIn.get('email')
    targetUser = mongo.db.users.find_one({'email': useremail})
    targetGroup = targetEvent.get('groupid')
    groups = targetUser.get('groups')

    if targetGroup not in groups:
        myId = targetUser.get('_id')
        mongo.db.users.update_one({'_id': myId}, {'$push': {'groups': targetGroup}})

    LOGGER.info(targetUser)
    LOGGER.info(targetEvent)

    userId = targetUser.get("_id")
    myId = targetEvent.get("_id")
    if myId != None:
        event = mongo.db.events.find_one({'_id':myId})
        if userId not in event['checkedInUsers']:
            mongo.db.events.update_one({'_id': myId}, {'$push': {'checkedInUsers': userId}})
            return "Successfully checked in"
        else:
            return "Looks like you're already checked in!"

'''
@params
email: user email
'''
@app.route("/userGroups", methods=['POST'])
def getAllGroupsForUser():
    LOGGER.info('recieved')
    theUser = request.get_json()
    useremail = theUser.get('email')
    targetUser = mongo.db.users.find_one({'email': useremail})
    groups = targetUser.get('groups')
    return dumps(groups)

'''
@params
group: some group name as a query param
'''
@app.route("/exportToSlack", methods=['POST'])
def slackExport():
    groupName = request.args.get('group')
    group = mongo.db.groups.find_one({"name": groupName})
    users = group.get('users')

    team = slack_client.api_call("users.list")
    LOGGER.debug(team)
    teamEmails = ()
    for user in team:
        try:
            LOGGER.debug(user)
            email = user.get('profile').get('email')
            teamEmails.add(email)
        except:
            pass

    emails =()
    for user in users:
        u = mongo.db.users.find_one({"_id": user})
        email = u.get('email')
        if email not in teamEmails:
            callstring = "users.admin.invite?email={}".format(email)
            LOGGER.info(callstring)
            slack_client.api_call(callstring)


    return "invites sent"

'''
@params
location: a JSON with a latitude and longitude info
'''
@app.route("/getNearbyEvents", methods = ['POST'])
def getNearbyEvents():
    LOGGER.info('recieved')
    location = request.get_json()
    curLong = location.get('longitude')
    curLat = location.get('latitude')
    LOGGER.info(curLong)
    LOGGER.info(curLat)
    myEvents = mongo.db.events.find({"active": True})
    nearbyEvents = []
    for x in myEvents:
        if distance(float(curLat), float(x.get('latitude')), float(curLong), float(x.get('longitude'))) < 2 :
            nearbyEvents.append(x.get('name'))
    return dumps(nearbyEvents)

'''
@params
name: name of a group
'''
@app.route("/pingAllMembers", methods = ['POST'])
def getAllMembers():
    LOGGER.info('recieved')
    groupinfo = request.get_json()
    groupName = groupinfo.get('name')
    targetGroup = mongo.db.groups.find_one({"name": groupName})
    groupMembers = targetGroup.get('users')
    return dumps(groupMembers)

'''
@params
name: name of the 3event you want to close
'''
@app.route("/closeEvent", methods = ['POST'])
def closeEvent():
    LOGGER.info('recieved')
    eventinfo = request.get_json()
    eventName = eventinfo.get('name')
    mongo.db.events.update_one({'name': eventName}, {'$set':{"Active": False}})
    return 'success'

'''
@params
lat1, lat2, long1, long2
calculate distance helper function
'''
def distance(lat1, lat2, long1, long2):
    dlong = long2 - long1
    dlat = lat2 -lat1
    a = (math.sin(dlat/2))**2 + math.cos(lat1) * math.cos(lat2) * (math.sin(dlong/2))**2
    c = 2 * math.atan2( math.sqrt(a), math.sqrt(1-a) )
    d = 3961 * c
    return d


# LAUNCH APP
if __name__ == "__main__":
        port = int(os.environ.get("PORT", 5000))
        LOGGER.info("Getting Flask up and running...\n")
        if slack_client.api_call("api.test") is not None:
            LOGGER.info("Connected to Slack!")
        app.run(host = '127.0.0.1' , port = port)
