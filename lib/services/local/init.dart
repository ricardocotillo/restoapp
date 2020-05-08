import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> init() async {
  final Future<Database> database = openDatabase(join(await getDatabasesPath(), 'resto.db'), onCreate: (db, version) => db.execute('CREATE TABLE cart(id INTEGER PRIMARY KEY, )'));
}