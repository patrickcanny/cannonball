class User {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber
  });

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['f_name'],
        lastName = json['l_name'],
        email = json['email'],
        phoneNumber = json['phone'];

  Map<String, dynamic> toJson() =>
  {
    'f_name': firstName,
    'l_name': lastName,
    'email': email,
    'phone': phoneNumber,
    'groups': []
  };
}