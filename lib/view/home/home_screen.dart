// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thiran2/controller/controller.dart';
import 'package:thiran2/model/model.dart';
import 'package:thiran2/view/home/widget/item_tile.dart';
import 'widget/app_bar.dart';
import 'widget/no_internet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var notifier;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.fetchDataIfConnected();
    });
    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          notifier = ref.read(githubProvider.notifier);
          final githubState = ref.watch(githubProvider);
          final repo = githubState.github;

          if (!githubState.hasConnection && githubState.github.isEmpty) {
            return const NoInternet();
          } else {
            if (repo.isNotEmpty) {
              return ListView.builder(
                itemCount: repo.length + 1,
                itemBuilder: (context, index) {
                  if (index < repo.length) {
                    final Item repository = repo[index];
                    return ItemTile(repo: repository);
                  } else {
                    if (!githubState.endOfPage) {
                      notifier.fetchData();
                      return const Center(child: CircularProgressIndicator());
                    } else {
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
              notifier.fetchData();
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}
