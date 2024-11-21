import 'package:makosso_app/model/commentaire.dart';
import 'package:makosso_app/model/user.dart';

import 'like.dart';

class FilActualite {
  FilActualite({
    required this.id,
    required this.uid,
    required this.type,
    required this.title,
    required this.description,
    required this.url,
    required this.is_feeded,
    this.created_at,
    this.updated_at,
  });

  final int id;
  final String uid;
  final String type;
  final String title;
  final String description;
  final String url;
  final int is_feeded;
  final DateTime? created_at;
  final DateTime? updated_at;

  factory FilActualite.fromJson(Map<String, dynamic> json) {
    return FilActualite(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? 'vide',
      type: json['type'] ?? 'vide',
      title: json['title'] ?? 'vide',
      description: json['description'] ?? 'vide',
      url: json['url'] ?? 'vide',
      is_feeded: json['is_feeded'] ?? 0,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updated_at: json['updated_at'] != null
          ? DateTime.parse(
              json['updated_at'],
            )
          : DateTime.now(),
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
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }
}
