import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DescriptionShimmer extends StatelessWidget {
  const DescriptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 214, 214, 214),
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 16,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 4)),
            Container(
                height: 16,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 4)),
            Container(
                height: 16,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 4)),
          ],
        ),
      ),
    );
  }
}