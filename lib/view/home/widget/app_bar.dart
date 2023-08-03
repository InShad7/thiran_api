
import 'package:flutter/material.dart';
import 'package:thiran2/view/home/widget/alert.dart';
import 'package:thiran2/view/utils/utils.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({super.key});

  @override
  final Size preferredSize =const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: teal,
      title: const Text('GitHub'),
      actions: [
        IconButton(
          onPressed: () {
            alertBox(context: context);
          },
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }
}
