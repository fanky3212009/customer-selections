import 'dart:io';

import 'package:customer_selections/Models/customer_profile.dart';
import 'package:customer_selections/Models/item_selection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'ExhibitionApp.db';
  static const _databaseVersion = 1;

  static const tableProfile = 'customer_profile';
  static const tableSelections = 'item_selection';

  static const columnId = 'id';
  static const columnCreateDate = 'createDate';
  static const columnExhibition = 'exhibition';
  static const columnSalesman = 'salesman';
  static const columnGuest = 'guest';
  static const columnCompany = 'company';
  static const columnName = 'name';
  static const columnContact = 'contact';
  static const columnRemarks = 'remarks';
  static const columnCustomerId = 'customerId';
  static const columnItemCode = 'itemCode';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  late Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProfile (
        $columnId INTEGER PRIMARY KEY,
        $columnCreateDate TEXT NOT NULL,
        $columnExhibition TEXT NOT NULL,
        $columnSalesman TEXT NOT NULL,
        $columnGuest TEXT NOT NULL,
        $columnCompany TEXT NOT NULL,
        $columnName TEXT NOT NULL,
        $columnContact TEXT NOT NULL,
        $columnRemarks TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableSelections (
        $columnId INTEGER PRIMARY KEY,
        $columnCustomerId INTEGER NOT NULL,
        $columnItemCode TEXT NOT NULL
      )
      ''');
  }

  Future<int> insertProfile(CustomerProfile profile) async {
    Database db = await instance.database;
    return await db.insert(tableProfile, profile.toMap());
  }

  Future<int> insertSelection(ItemSelection selection) async {
    Database db = await instance.database;
    return await db.insert(tableSelections, selection.toMap());
  }
}
