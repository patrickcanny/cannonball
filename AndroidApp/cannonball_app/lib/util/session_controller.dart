import 'package:cannonball_app/models/User.dart';

class SessionController {
  static User currentUser;

  static String currentUserId() {
    return currentUser.email;
  }

  Map<String, dynamic> toJson() => currentUser.toJson();
}