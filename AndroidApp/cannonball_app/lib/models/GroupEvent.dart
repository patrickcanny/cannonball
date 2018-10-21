class GroupEvent {
  String name;
  String email;

  GroupEvent({
    this.name,
    this.email
  });

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email
      };
}