class Groups{
  List<String> groups;

  Groups({
    this.groups
  });

  Map<String, dynamic> toJson() =>
      {
        'groups': groups
      };
}