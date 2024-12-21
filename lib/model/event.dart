import 'package:flutter/foundation.dart';

class Event {
  final int id;
  final String uid;
  final int userId;
  final String urlImage;
  final String title;
  final String description;
  final String
      date; // Utilisez `String` si vous ne voulez pas convertir en `DateTime` ici
  final String lieu;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  Event({
    required this.id,
    required this.uid,
    required this.userId,
    required this.urlImage,
    required this.title,
    required this.description,
    required this.date,
    required this.lieu,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory pour créer un objet `Event` à partir d'un JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      uid: json['uid'] as String,
      userId: json['user_id'] as int,
      urlImage: json['url_image'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      lieu: json['lieu'] as String,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  // Méthode pour convertir un objet `Event` en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'user_id': userId,
      'url_image': urlImage,
      'title': title,
      'description': description,
      'date': date,
      'lieu': lieu,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'Event(id: $id, title: $title, date: $date, lieu: $lieu)';
  }
}
