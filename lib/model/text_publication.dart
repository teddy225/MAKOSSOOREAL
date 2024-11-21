class TextPublication {
  TextPublication({
    required this.id,
    required this.uid,
    required this.type,
    required this.title,
    required this.description,
    required this.url,
    required this.is_feeded,
  });

  final int id;
  final String uid;
  final String type;
  final String title;
  final String description;
  final String url;
  final int is_feeded;

  factory TextPublication.fromJson(Map<String, dynamic> json) {
    return TextPublication(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? 'vide',
      type: json['type'] ?? 'vide',
      title: json['title'] ?? 'vide',
      description: json['description'] ?? 'vide',
      url: json['url'] ?? 'vide',
      is_feeded: json['is_feeded'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'type': type,
      'title': title,
      'description': description,
      'url': url,
      'is_feeded': is_feeded,
    };
  }
}
