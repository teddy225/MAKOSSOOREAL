import 'package:flutter/material.dart';

class RowHome extends StatelessWidget {
  const RowHome({required this.titreRecent, super.key});
  final String titreRecent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titreRecent,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          InkWell(
            onTap: () {},
            child: Text(
              'Voir plus',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ],
      ),
    );
  }
}
