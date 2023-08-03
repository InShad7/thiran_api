import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thiran2/controller/controller.dart';
import 'package:thiran2/model/model.dart';
import 'package:thiran2/view/home/widget/item_tile.dart';
import 'widget/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer<GithubProvider>(
        builder: (context, value, child) {
          final repo = value.getDatas;
          if (repo.isNotEmpty) {
            return ListView.builder(
              itemCount: repo.length + 1,
              itemBuilder: (context, index) {
                if (index < repo.length) {
                  final Item repository = repo[index];
                  return ItemTile(repo: repository);
                } else {
                  if (!value.isEnd) {
                    value.fetchData();
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    value.fetchData();
                    Fluttertoast.showToast(msg: 'No more repository found');
                    return const Center(
                      child: Text('No more repository found'),
                    );
                  }
                }
              },
            );
          } else if (repo == null) {
            return const Center(child: Text('No data found'));
          } else {
            value.fetchData();
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
