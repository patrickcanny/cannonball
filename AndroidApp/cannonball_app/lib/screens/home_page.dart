import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cannonball_app/models/Coordinates.dart';
import 'package:cannonball_app/models/UserCheckIn.dart';
import 'package:cannonball_app/util/requests.dart';
import 'package:cannonball_app/util/session_controller.dart';
import 'package:cannonball_app/util/pop_up.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

var apiKey = "AIzaSyAAFXiekUVvfsAe1miEFxau1t-XG1oL5yg";
Map<String, double> _currentLocation;
Future<Position> position =  Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
var events;
var groups;

class MapsDemo extends StatelessWidget {
  MapsDemo(this.mapWidget, this.controller);

  final Widget mapWidget;
  final GoogleMapController controller;

  void retreiveEvents() async {
    Coordinates coords = new Coordinates();
    coords.latitude = _currentLocation["latitude"];
    coords.longitude = _currentLocation["longitude"];
    events = json.decode(await(Requests.POST(coords.toJson(), "/getNearbyEvents")));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(child: mapWidget),
          RaisedButton(
            child: const Text('Update Current Location'),
            onPressed: () {
              retreiveEvents();
              controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: 270.0,
                  target: LatLng(_currentLocation["latitude"], _currentLocation["longitude"]),
                  tilt: 35.0,
                  zoom: 17.0,
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}

final GoogleMapOverlayController controller =
GoogleMapOverlayController.fromSize(width: 325.0, height: 280.0);
final Widget mapWidget = GoogleMapOverlay(controller: controller);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  Image image1;

  Map data;
  List userData;

  void checkIn(String name, String email) async {
    UserCheckIn check = new UserCheckIn();
    check.name = name;
    check.email = email;
    Requests.POST(check.toJson(), "/checkInUser");
  }

  Future getData() async {
    http.Response response = await http.get(
        "https://reqres.in/api/users?page=2");
    data = json.decode(response.body);
    setState(() {
      userData = data["data"];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    final GoogleMapOverlayController controller =
    GoogleMapOverlayController.fromSize(width: 300.0, height: 200.0);
    final Widget mapWidget = GoogleMapOverlay(controller: controller);

    _locationSubscription =
        _location.onLocationChanged().listen((Map<String,double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
  }

  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;
  }

  void slackExport(String group) async {
    String query = "/exportToSlack?group="+group;
    Requests.POST(null, query);
  }

  void retreiveGroups() async {
    Map m = {"email": SessionController.currentUserId()};
    groups = json.decode(await(Requests.POST(m, "/userGroups")));
    print(groups);
  }

  @override
  Widget build(BuildContext context) {
    retreiveGroups();
    List<Widget> widgets;
    if (_currentLocation == null) {
      widgets = new List();
    } else {
      widgets = [
        new Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=AIzaSyAAFXiekUVvfsAe1miEFxau1t-XG1oL5yg"),
      ];
    }

    widgets.add(new Center(
        child: new Text(_currentLocation != null
            ? 'Continuous location: $_currentLocation\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
        child: new Text(_permission
            ? 'Has permission : Yes'
            : "Has permission : No")));
    final Widget mapWidget = GoogleMapOverlay(controller: controller);
    final mapController = controller.mapController;

    return Scaffold(
      appBar: AppBar(

        title: Text("GPS Check In"),
        actions: <Widget>[

          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              final location = LatLng(_currentLocation["latitude"], _currentLocation["longitude"]);
              mapController.markers.clear();
              mapController.addMarker(MarkerOptions(
                position: location,
              ));
              mapController.animateCamera(
                CameraUpdate.newLatLngZoom(
                    location, 15.0),
              );
            },
          ),
        ],
        backgroundColor: Colors.green,
      ),
      drawer: new Drawer( child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(accountEmail: new Text(SessionController.currentUserId()), /*currentAccountPicture: new Image.asset('varun'), */decoration: BoxDecoration(color: new Color.fromRGBO(36, 120, 65, 1.0),
         ),),

          ListTile(
            title: new Text(
              "Create Your Group",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,

              ),),
            onTap:() {
              PopUp.renderPopUp(context, 'Create Group', 'Group Name', 'newGroup');
            },

          ),

          new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("\nYour Groups", style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),),
            ],
          ),
          new Container(

            height: 600.0,
            child: new ListView.builder(
              itemCount: events == null ? 0 : events.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: new ExpansionTile(
                    title: new Text(
                      "${events[index]}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),),
                    children: <Widget>[
                      new RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed:(){ PopUp.renderPopUp(context, 'Create Event', 'Event Name', 'newEvent'); },
                        child: new Text("Create Event"),

                      ),
                      new RaisedButton(
                       padding: const EdgeInsets.all(8.0),
                       textColor: Colors.white,
                       color: Colors.green,
                       child: new Text("Export Group to Slack"),
                        onPressed:() {
                          slackExport(groups[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            MapsDemo(mapWidget, controller.mapController),

            new Container(
              height: 220.0,
              child: new ListView.builder(
                itemCount: events == null ? 0 : events.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: new ExpansionTile(
                      title: new Text(
                        "${events[index]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),),
                      children: <Widget>[
                        new RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed:(){ checkIn(events[index], SessionController.currentUserId()); },
                          child: new Text("Check in to group"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
