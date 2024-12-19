import 'package:makosso_app/model/user.dart';

class Comment {
  final int id; // ID du commentaire.
  final String content; // Contenu du commentaire.
  final int postId; // ID de la publication associée.
  final User user; // Auteur du commentaire.

  Comment({
    required this.id,
    required this.content,
    required this.postId,
    required this.user,
  });

  // Méthode pour convertir un objet JSON en instance de Comment.
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'], // ID du commentaire.
      content: json['content'], // Contenu du commentaire.
      postId: json['post_id'], // ID de la publication.
      user: User.fromJson(json['user']), // Auteur du commentaire.
    );
  }

  // Méthode pour convertir une instance de Comment en JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'post_id': postId,
      'user': user.toJson(),
    };
  }
}
