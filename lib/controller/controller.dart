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
            hasConnection: false,
          ),
        );
  DatabaseManager dbManager = DatabaseManager(); //instance of Database

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
      Fluttertoast.showToast(
        msg: state.isThirty ? 'updated to 30 days' : 'updated to 60 days',
      );
    } else {
      Fluttertoast.showToast(msg: "Please turn on Mobile data or Wifi");
    }
  }

//fun to fetch data from api
  Future<void> fetchData() async {
    print("inside fetchData");

    if (state.hasConnection) {
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

              await dbManager.initDataBase(); //initialize the db
              await dbManager.saveToLocalStorage(items); //save to localstorage
            } else {
              state = state.copyWith(
                  endOfPage: true); //if items are empty then endofpage
            }
          }
        } else {
          print('API call failed: ${response.statusCode}');
          await fetchDataIfConnected();
        }
      } catch (e) {
        print('Error fetching data: $e');
        await fetchDataIfConnected();
      }
    } else {
      // load data from local storage when not connected to the internet
      await loadFromLocalStorage();
    }
  }

  // function to load data from local storage
  Future<void> loadFromLocalStorage() async {
    try {
      //load data from local storage from db class
      await dbManager.initDataBase();
      final List<Item> items = await dbManager.loadFromLocalStorage();
      if (items.isNotEmpty) {
        state = state.copyWith(
          github: items,
        );
      }
    } catch (e) {
      print('Error loading data from local storage: $e');
    }
  }

  //  fun to check the internet is connected or not
  fetchDataIfConnected() async {
    print('fetchIfConnected');
    final connectivityResult =
        await InternetConnectionChecker().connectionStatus;
    if (connectivityResult == InternetConnectionStatus.connected) {
      state = state.copyWith(hasConnection: true);
      return true;
    } else {
      state = state.copyWith(hasConnection: false);
      await loadFromLocalStorage();
      Fluttertoast.showToast(msg: "Please turn on Mobile data or Wifi");
      return false;
    }
  }
}