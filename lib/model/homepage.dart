class Mark {
  int id;
  String subTitle;
  String url;
  String title;
  String icon;
  String picture;
  List<TagRelation> tags;

  Mark(
      {this.id,
      this.url,
      this.title,
      this.subTitle,
      this.icon,
      this.picture,
      this.tags});

  factory Mark.fromJson(Map<String, dynamic> json) {
    List<TagRelation> tags = List.empty(growable: true);
    if (json['tags'] != null) {
      for (var tag in json['tags']) {
        tags.add(TagRelation.fromJson(tag));
      }
    }

    return Mark(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      subTitle: json['sub_title'],
      picture: json['picture'],
      icon: json['icon'],
      tags: tags,
    );
  }
}

class TagRelation {
  TagRelation({this.name, this.relationID});
  int relationID;
  String name;

  factory TagRelation.fromJson(Map<String, dynamic> json) {
    return TagRelation(
      name: json['name'],
      relationID: json['id'],
    );
  }
}
