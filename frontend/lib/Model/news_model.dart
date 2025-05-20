class NewsModel {
  String? title;
  String? description;
  String? imageUrl;
  DateTime? createdAt;

  NewsModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: json['createdAt'] as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
    };
  }
}
