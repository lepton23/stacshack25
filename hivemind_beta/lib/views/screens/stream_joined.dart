import 'package:flutter/material.dart';

class StreamJoinedPage extends StatelessWidget {
  const StreamJoinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Joined Stream',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Icon(
            Icons.check_circle,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
