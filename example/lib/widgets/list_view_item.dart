import 'package:flutter/material.dart';

class ListViewItem extends StatelessWidget {
  const ListViewItem({
    required this.item,
    required this.index,
    super.key,
  });

  final String item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Item $item'),
      subtitle: Text('Item ${index + 1}'),
    );
  }
}
