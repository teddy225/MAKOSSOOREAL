import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class Description extends StatefulWidget {
  const Description({required this.description, super.key});
  final String description;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ReadMoreText(
          textAlign: TextAlign.left,
          """${widget.description}""",
          style: Theme.of(context).textTheme.bodyMedium,
          trimMode: TrimMode.Line,
          trimLines: 3,
          trimCollapsedText: 'Afficher la suite',
          trimExpandedText: ' Afficher moin',
          moreStyle: Theme.of(context).textTheme.bodySmall,
          lessStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
