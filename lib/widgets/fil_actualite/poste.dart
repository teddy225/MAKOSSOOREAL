import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Poste extends StatelessWidget {
  const Poste({required this.imageUrl, super.key});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: const Color.fromARGB(255, 182, 182, 182),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          errorWidget: (context, url, error) => Icon(Icons.error),
        ));
  }
}
