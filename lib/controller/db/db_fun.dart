import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:thiran2/model/model.dart';

class DatabaseManager {
  late Database db;
//inintialize the database
  Future<void> initDataBase() async {
    db = await _openDatabase();
  }

//open the database or creating a new one
  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'git.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE git (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT,star INTEGER)',
        );
      },
    );
  }

//function to load data from local storage
  loadFromLocalStorage() async {
    try {
      //retrieve the data from db
      final List<Map<String, dynamic>> data = await db.query('git');
      //if data not empty then do
      if (data.isNotEmpty) {
        return data
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
            .toList();
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

        // iterate through items and insert unique ones
        for (var item in items) {
          var existingItem = await txn.rawQuery(
            'SELECT * FROM git WHERE name = ? AND description = ?',
            [item['name'], item['description']],
          );

          if (existingItem.isEmpty) {
            await txn.insert('git', {
              'id': newId++,
              'name': item['name'],
              'description': item['description'],
              'star': item['stargazers_count'],
            });
          }
        }
      });
      print('saved to local storage');
    } catch (e) {
      print('Error saving data to local storage: $e');
    }
  }

  // Future<void> clearGitTable() async {
  //   try {
  //     await db.delete('git'); // delete all rows from the git table
  //     print('Cleared git table');
  //   } catch (e) {
  //     print('Error clearing git table: $e');
  //   }
  // }
}
