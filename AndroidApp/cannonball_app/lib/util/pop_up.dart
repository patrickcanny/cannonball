import 'package:flutter/material.dart';
import 'package:cannonball_app/models/GroupEvent.dart';
import 'package:cannonball_app/util/requests.dart';
import 'package:cannonball_app/util/session_controller.dart';

class PopUp {
  static Future<Null> renderPopUp(context, actionText, labelText, action) async {
    final textController = TextEditingController();

    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(actionText),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: textController,
                  decoration: new InputDecoration(
                      labelText: labelText
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Create'),
              onPressed: () {
                GroupEvent group = new GroupEvent();
                group.name = textController.text;
                group.email = SessionController.currentUserId();

                Requests.POST(group.toJson(), action);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}