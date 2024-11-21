import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PosteShimmer extends StatelessWidget {
  const PosteShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 179, 179, 179),
      highlightColor: Colors.white,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: const Color.fromARGB(255, 160, 160, 160),
        ),
      ),
    );
  }
}