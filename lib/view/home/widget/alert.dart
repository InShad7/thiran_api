import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thiran2/controller/controller.dart';
import '../../utils/utils.dart';

void alertBox({context}) {
  showModalBottomSheet(
    backgroundColor: grey2,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18),
      ),
    ),
    context: context,
    builder: (context) => Consumer(
      builder: (context, value, child) {
        final notifier = value.read(githubProvider.notifier);
        final provider = value.read(githubProvider);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            kHeight,
            SizedBox(
              width: 400,
              height: 70,
              child: TextButton(
                onPressed: () async {
                  notifier.changeNumberOfDays();
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: provider.isThirty
                        ? 'updated to 60 days'
                        : 'updated to 30 days',
                  );
                },
                child: Text(
                  provider.isThirty ? '60 days' : '30 days',
                  style: TextStyle(color: teal, fontSize: 18),
                ),
              ),
            ),
            const Divider(indent: 60, endIndent: 60),
            SizedBox(
              height: 65,
              width: 400,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: red, fontSize: 18),
                ),
              ),
            ),
            kHeight,
          ],
        );
      },
    ),
  );
}
