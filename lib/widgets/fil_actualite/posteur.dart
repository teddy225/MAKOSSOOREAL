import 'package:flutter/material.dart';

class Posteur extends StatelessWidget {
  const Posteur({required this.dateposte, super.key});
  final DateTime dateposte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            backgroundImage: AssetImage('assets/images/p6.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Générale Camille MAKOSSO',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(dateposte.toString(),
                    style: Theme.of(context).textTheme.titleSmall)
              ],
            ),
          ),
        ],
      ),
    );
  }
}