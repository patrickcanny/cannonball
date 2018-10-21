class SlackGroup {
  String group;

  SlackGroup({
    this.group
  });

  Map<String, dynamic> toJson() =>
      {
        'group': group
      };
}