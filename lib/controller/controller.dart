import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import '/model/model.dart';
import 'package:http/http.dart' as http;
import '/model/riverpod/riverpod_model.dart';
import 'db/db_fun.dart';

final githubProvider =
    StateNotifierProvider<GithubNotifier, GithubState>((ref) {
  return GithubNotifier();
});

class GithubNotifier extends StateNotifier<GithubState> {
  GithubNotifier()
      : super(
          GithubState(
            github: [],
            currentPage: 1,
            endOfPage: false,
            isThirty: false,
            hasConnection: true,
          ),
        );

  //get the date by days 30 or 60
  String getNumberOfDays() {
    final now = DateTime.now();
    final daysAgo = state.isThirty ? 30 : 60;
    final days = now.subtract(Duration(days: daysAgo));
    return DateFormat('yyyy-MM-dd').format(days);
  }

  // //change the number of days by 30 or 60
  void changeNumberOfDays() {
    if (state.hasConnection) {
      state = state.copyWith(
        isThirty: !state.isThirty,
        github: [],
        currentPage: 1,
        endOfPage: false,
      );
      fetchData();
    } else {
      Fluttertoast.showToast(msg: "Please turn on Mobile data or Wifi");
    }
  }

  //fuction to fetch the data from the api
  Future<void> fetchData() async {
    print('inside fetch data');
    try {
      final day = getNumberOfDays();

      final url =
          'https://api.github.com/search/repositories?q=created:%3E$day&sort=stars&order=desc&page=${state.currentPage.toString()}&per_page=10';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['items'] is List) {
          List<dynamic> items = result['items'];
          if (items.isNotEmpty) {
            state = state.copyWith(
              github: [
                ...state.github, //adding the existing list
                ...items
                    .map((item) => Item.fromJson(item)) //adding the new list
              ],
              currentPage: state.currentPage + 1,
            );
            saveToLocalStorage(items);
          } else {
            state = state.copyWith(endOfPage: true);
          }
        }
      } else {
        print('API call failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

//function to load data from local storage
  Future<void> loadFromLocalStorage() async {
    try {
      final List<Map<String, dynamic>> data = await db.query('git');
      //if data not empty then do
      if (data.isNotEmpty) {
        state = state.copyWith(
            github: data
                .map((item) => Item(
                      id: item['id'],
                      name: item['name'],
                      fullName: '',
                      private: false,
                      owner: Owner(
                          login: '',
                          id: 0,
                          nodeId: '',
                          avatarUrl: '',
                          url: '',
                          starredUrl: ''),
                      htmlUrl: '',
                      description: item['description'] ?? 'No description',
                      size: 0,
                      stargazersCount: item['star'] ?? 0,
                    ))
                .toList());
      }
    } catch (e) {
      print('Error loading data from local storage: $e');
    }
  }

  //save the data to local storage
  Future<void> saveToLocalStorage(List<dynamic> items) async {
    try {
      await db.transaction((txn) async {
        int lastUsedId = 0;
        List<Map<String, dynamic>> result =
            await txn.rawQuery('SELECT MAX(id) as lastId FROM git');
        lastUsedId = result[0]['lastId'] ?? 0;

        int newId = lastUsedId + 1; //updating the last used id
        lastUsedId = newId;
        //storing each of the data in to local storage
        for (var item in items) {
          await txn.insert('git', {
            'id': newId++,
            'name': item['name'],
            'description': item['description'],
            'star': item['stargazers_count'],
          });
        }
      });
    } catch (e) {
      print('Error saving data to local storage: $e');
    }
  }

  //  fun to check the internet is connected or not
  fetchDataIfConnected() async {
    final connectivityResult =
        await InternetConnectionChecker().connectionStatus;
    if (connectivityResult == InternetConnectionStatus.connected) {
      state = state.copyWith(hasConnection: true);
      return await fetchData();
    } else {
      state = state.copyWith(hasConnection: false);
      Fluttertoast.showToast(msg: "Please turn on Mobile data or Wifi");

      return await loadFromLocalStorage();
    }
  }
}
