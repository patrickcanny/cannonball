class NewEvent {
  String name;
  String email;
  String latitude;
  String longitude;

  NewEvent({
    this.name,
    this.email,
    this.latitude,
    this.longitude
  });

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'latitude': latitude,
        'longitude': longitude
      };
}