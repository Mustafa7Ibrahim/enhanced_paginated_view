import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Enhanced Paginated View',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
