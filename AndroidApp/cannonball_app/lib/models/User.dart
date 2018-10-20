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

  Map<String, dynamic> toJson() =>
  {
    'f_name': firstName,
    'l_name': lastName,
    'email': email,
    'phone': phoneNumber,
    'groups': ''
  };
}