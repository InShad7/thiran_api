import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thiran2/model/model.dart';
import 'package:http/http.dart' as http;

import 'db/db_fun.dart';

class GithubProvider extends ChangeNotifier {
  List<dynamic> github = [];
  int currentPage = 1;
  bool endOfPage = false;
  bool isThirty = false;

//get the date by days 30 or 60
  getNumberOfDays() {
    final now = DateTime.now();
    final daysAgo = isThirty ? 30 : 60;
    final days = now.subtract(Duration(days: daysAgo));
    return DateFormat('yyyy-MM-dd').format(days);
  }

//change the number of days by 30 or 60
  changeNumberOfDays() {
    isThirty = !isThirty;
    github.clear();
    currentPage = 1;
    fetchData();
  }

//calling the function
  List<dynamic> get getDatas => github;
  bool get isEnd => endOfPage;


//fuction to fetch the data from the api
  Future<void> fetchData() async {
    try {
      final day = getNumberOfDays();
      if (endOfPage) return;
      final url =
          'https://api.github.com/search/repositories?q=created:%3E$day&sort=stars&order=desc&page=${currentPage.toString()}&per_page=15';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        //if successful then do this
        var result = json.decode(response.body);
        if (result['items'] is List) {
          List<dynamic> items = result['items'];
          if (items.isNotEmpty) {
            github.addAll(items.map((item) => Item.fromJson(item)));//add to list 
            currentPage++; // Increment the current page
            notifyListeners();
            saveToLocalStorage(items); // Save to local storage
          } else {
            endOfPage = true;
          }
        }
      } else {
        // if API call fails, load data from local storage
        print('API call failed: ${response.statusCode}');
        await loadFromLocalStorage();
      }
    } catch (e) {
      print('Error fetching data: $e');
      // if there's an error, load data from local storage
      await loadFromLocalStorage();
    }
  }


//function to load data from local storage

  Future<void> loadFromLocalStorage() async {
    try {
      final List<Map<String, dynamic>> data = await db.query('git');
      //if data not empty then do
      if (data.isNotEmpty) {
        github.clear();    //clear the list then add to the list
        github.addAll(
          data.map(
            (item) => Item(
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
            ),
          ),
        );
        notifyListeners(); //update the ui

        // for (var item in github) {
        //   print(
        //       'ID: ${item.id}, Name: ${item.name}, Description: ${item.description},star: ${item.star}');
        // }
      }
    } catch (e) {
      print('Error loading data from local storage: $e');
    }
  }
//save the data to local storage
  saveToLocalStorage(List<dynamic> items) async {
    try {
      await db.transaction((txn) async {
        int lastUsedId = 0;
        List<Map<String, dynamic>> result =
            await txn.rawQuery('SELECT MAX(id) as lastId FROM git');
        lastUsedId = result[0]['lastId'] ?? 0;

        int newId = lastUsedId + 1;//updating the last used id
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
      // for (var item in github) {
      //   print(
      //       'ID: ${item.id}, Name: ${item.name}, Description: ${item.description},star: ${item.star}');
      // }
    } catch (e) {
      print('Error saving data to local storage: $e');
    }
  }
}
