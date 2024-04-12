// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   // Singleton instance
//   static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

//   // Private constructor
//   DatabaseHelper._privateConstructor();

//   // Factory constructor
//   factory DatabaseHelper() {
//     return _instance;
//   }

//   static const _databaseName = "newone.db";
//   static const _databaseVersion = 1;

//   static const table = 'Newone';

//   static const columnId = 'id';
//   static const columnMobileNum = 'number';
//   static const columnEmailId = 'email';
//   static const columnEmbedding = 'embedding';
//   static const columnUpiId = 'upiId';
//   static const columnPayee = 'payee';

//   late Database _db;

//   // this opens the database (and creates it if it doesn't exist)
//   Future<void> init() async {
//     final documentsDirectory = await getApplicationDocumentsDirectory();
//     final path = join(documentsDirectory.path, _databaseName);
//     _db = await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _onCreate,
//     );
//   }

//   // SQL code to create the database table
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $table (
//             $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
//             $columnMobileNum TEXT NOT NULL,
//             $columnEmailId TEXT NOT NULL,
//             $columnUpiId TEXT NOT NULL,
//             $columnPayee TEXT NOT NULL,
//             $columnEmbedding TEXT NOT NULL
//           )
//           ''');
//   }

//   Future<int> deleteRow(int id) async {
//     return await _db.delete(
//       table,
//       where: '$columnId = ?',
//       whereArgs: [id],
//     );
//   }

//   // Helper methods

//   // Inserts a row in the database where each key in the Map is a column name
//   // and the value is the column value. The return value is the id of the
//   // inserted row.
//   Future<int> insert(Map<String, dynamic> row) async {
//     print('Details: $row');
//     return await _db.insert(table, row);
//   }

//   // All of the rows are returned as a list of maps, where each map is
//   // a key-value list of columns.
//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     return await _db.query(table);
//   }

//   // All of the methods (insert, query, update, delete) can also be done using
//   // raw SQL commands. This method uses a raw query to give the row count.
//   Future<int> queryRowCount() async {
//     final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
//     return Sqflite.firstIntValue(results) ?? 0;
//   }

//   // We are assuming here that the id column in the map is set. The other
//   // column values will be used to update the row.
//   Future<int> update(Map<String, dynamic> row) async {
//     int id = row[columnId];
//     return await _db.update(
//       table,
//       row,
//       where: '$columnId = ?',
//       whereArgs: [id],
//     );
//   }

//   // Deletes the row specified by the id. The number of affected rows is
//   // returned. This should be 1 as long as the row exists.
//   Future<int> delete(int id) async {
//     return await _db.delete(
//       table,
//       where: '$columnId = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<List<Map<String, dynamic>>> queryRowByPayee(String payee) async {
//     return await _db.query(
//       table,
//       where: '$columnPayee = ?',
//       whereArgs: [payee],
//     );
//   }

//   // Deletes all rows in the table. Returns the number of rows deleted.
//   Future<int> deleteAllRows() async {
//     return await _db.delete(table);
//   }

//   Future<void> close() async {
//     await _db.close();
//   }
// }
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  // Private constructor
  DatabaseHelper._privateConstructor();

  // Factory constructor
  factory DatabaseHelper() {
    return _instance;
  }

  static const _databaseName = "newone.db";
  static const _databaseVersion = 1;

  static const table = 'Newone';

  static const columnId = 'id';
  static const columnMobileNum = 'number';
  static const columnEmailId = 'email';
  static const columnEmbedding = 'embedding';
  static const columnUpiId = 'upiId';
  static const columnPayee = 'payee';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnMobileNum TEXT NOT NULL,
            $columnEmailId TEXT,
            $columnUpiId TEXT NOT NULL,
            $columnPayee TEXT NOT NULL,
            $columnEmbedding TEXT NOT NULL
          )
          ''');
  }

  Future<int> deleteRow(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    print('Details: $row');
    return await _db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> queryRowByPayee(String payee) async {
    return await _db.query(
      table,
      where: '$columnUpiId = ?',
      whereArgs: [payee],
    );
  }

  // Deletes all rows in the table. Returns the number of rows deleted.
  Future<int> deleteAllRows() async {
    return await _db.delete(table);
  }

  Future<void> close() async {
    await _db.close();
  }
}
