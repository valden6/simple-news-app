class Source {

  final String name;
  final String id;
  final String description;
  final String url;
  final String category;
  final String country;

  Source(this.name, this.id, this.description, this.url, this.category, this.country);

  factory Source.fromJson(Map<String,dynamic> json){
    return Source(
      json["name"],
      json["id"],
      json["description"],
      json["url"],
      json["category"],
      json["country"],
    );
  }

}