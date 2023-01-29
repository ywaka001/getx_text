import 'package:sqflite/sqflite.dart';
import 'db_sqflite.dart';

class DbSingleton {
  static final DbSingleton _instance = DbSingleton._internal();
  late StudyDao dao;
  factory DbSingleton() {
    return _instance;
  }

  DbSingleton._internal();
}
