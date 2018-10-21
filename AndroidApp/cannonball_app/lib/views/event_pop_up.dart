import 'package:flutter/material.dart';
import 'package:cannonball_app/models/NewEvent.dart';
import 'package:cannonball_app/util/requests.dart';
import 'package:cannonball_app/util/session_controller.dart';

class EventPopUp {
  static Future<Null> renderPopUp(context, String latitude, String longitude) async {
    final textController = TextEditingController();

    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: textController,
                  decoration: new InputDecoration(
                      labelText: 'Event Name'
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Create'),
              onPressed: () {
                NewEvent event = new NewEvent();
                event.name = textController.text;
                print(event.name);
                event.email = SessionController.currentUserId();
                event.latitude = latitude;
                event.longitude = longitude;
                Requests.POST(event.toJson(), 'newEvent');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}