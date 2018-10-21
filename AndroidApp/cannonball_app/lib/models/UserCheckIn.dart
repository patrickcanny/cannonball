class UserCheckIn {
  String name;
  String email;
  

  UserCheckIn({
    this.name,
    this.email
  });

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'email': email
  };
}