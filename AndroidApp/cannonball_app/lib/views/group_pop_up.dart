import 'package:flutter/material.dart';
import 'package:cannonball_app/models/NewGroup.dart';
import 'package:cannonball_app/util/requests.dart';
import 'package:cannonball_app/util/session_controller.dart';

class GroupPopUp {
  static Future<Null> renderPopUp(context) async {
    final textController = TextEditingController();

    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: textController,
                  decoration: new InputDecoration(
                      labelText: 'Group Name'
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Create'),
              onPressed: () {
                NewGroup group = new NewGroup();
                group.name = textController.text;
                print(group.name);
                group.email = SessionController.currentUserId();


                Requests.POST(group.toJson(), 'newGroup');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}