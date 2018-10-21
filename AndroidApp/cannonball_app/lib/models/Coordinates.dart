class Coordinates {
  double latitude;
  double longitude;

  Coordinates({
    this.longitude,
    this.latitude
  });

  Map<String, dynamic> toJson() =>
  {
    'latitude': latitude,
    'longitude': longitude
  };
}