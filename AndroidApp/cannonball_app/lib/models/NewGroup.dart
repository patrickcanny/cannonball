class NewGroup {
  String email;
  String name;


  NewGroup({
    this.name,

    this.email
  });

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email
      };
}