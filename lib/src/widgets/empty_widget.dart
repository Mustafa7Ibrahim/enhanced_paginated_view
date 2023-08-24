import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 220,
            color: Colors.grey,
          ),

          /// [emptyText] is a string that will be used
          /// to show a message to the user when the list is empty
          Text(
            'No items found',
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}
