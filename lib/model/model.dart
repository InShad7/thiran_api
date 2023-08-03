class Item {
  int id;
  String name;
  String fullName;
  bool private;
  Owner owner;
  String htmlUrl;
  String? description;
  int size;
  int stargazersCount;

  Item({
    required this.id,
    required this.name,
    required this.fullName,
    required this.private,
    required this.owner,
    required this.htmlUrl,
    this.description,
    required this.size,
    required this.stargazersCount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        fullName: json["full_name"],
        private: json["private"],
        owner: Owner.fromJson(json["owner"]),
        htmlUrl: json["html_url"],
        description: json["description"] ?? 'No description',
        size: json["size"],
        stargazersCount: json["stargazers_count"],
      );
}

class Owner {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String url;
  String starredUrl;
  Owner({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.url,
    required this.starredUrl,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        login: json["login"],
        id: json["id"],
        nodeId: json["node_id"],
        avatarUrl: json["avatar_url"],
        url: json["url"],
        starredUrl: json["starred_url"],
      );
}
