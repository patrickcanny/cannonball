class NewGroup {
  String creator;
  List<String> users;
  List<String> admins;

  NewGroup({
    this.users,
    this.admins,
    this.creator
  });

  Map<String, dynamic> toJson() =>
      {
        'users': users,
        'admins': admins,
        'creator': creator
      };
}