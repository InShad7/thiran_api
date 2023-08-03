import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thiran2/controller/controller.dart';
import '../../utils/utils.dart';

void alertBox({context}) {
  final provider = Provider.of<GithubProvider>(context, listen: false);

  showModalBottomSheet(
    backgroundColor: grey2,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18),
      ),
    ),
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        kHeight,
        SizedBox(
          width: 400,
          height: 70,
          child: TextButton(
            onPressed: () async {
              provider.changeNumberOfDays();
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: provider.isThirty
                    ? 'updated to 30 days'
                    : 'updated to 60 days',
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
    ),
  );
}
