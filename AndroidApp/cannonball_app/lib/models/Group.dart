class Group {
  String name;
  String email;

  Group({
    this.name,
    this.email
  });

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email
      };
}