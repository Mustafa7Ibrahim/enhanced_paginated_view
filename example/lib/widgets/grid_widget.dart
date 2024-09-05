import 'package:flutter/material.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({
    super.key,
    required this.item,
    required this.index,
  });
  final String item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enhanced Paginated View',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              item,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Index: ${index + 1}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
