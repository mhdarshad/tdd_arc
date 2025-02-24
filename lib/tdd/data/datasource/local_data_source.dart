import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:objectbox/internal.dart' show ModelDefinition, ModelInfo;
import 'package:objectbox/objectbox.dart';
import 'package:sqflite/sqflite.dart';
import 'package:drift/drift.dart' as drift;
import 'package:realm/realm.dart' as realm;

enum DatabaseType { Hive, Isar, ObjectBox, Sqflite, Drift, Realm }

abstract class LocalDataSource {
  Future<void> saveData(String key, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getData(String key);
  Future<void> deleteData(String key);
}

class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseType databaseType;
  dynamic _database;



  LocalDataSourceImpl(this.databaseType) {
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    switch (databaseType) {
      case DatabaseType.Hive:
        await Hive.initFlutter();
        _database = await Hive.openBox('localStorage');
        break;
      case DatabaseType.Isar:
        _database = await Isar.open([], directory: '');
        break;
      case DatabaseType.ObjectBox:
        // _database = Store(getObjectBoxModel());
        break;
      case DatabaseType.Sqflite:
        _database = await openDatabase('local.db', version: 1,
            onCreate: (db, version) {
          db.execute('CREATE TABLE storage (key TEXT PRIMARY KEY, value TEXT)');
        });
        break;
      case DatabaseType.Drift:
        // _database = drift.DatabaseConnection.delayed(() async => drift.NativeDatabase.memory());
        break;
      case DatabaseType.Realm:
        // _database = realm.Realm(realm.Configuration([]));
        break;
    }
  }

  @override
  Future<void> saveData(String key, Map<String, dynamic> data) async {
    switch (databaseType) {
      case DatabaseType.Hive:
        await _database.put(key, jsonEncode(data));
        break;
      case DatabaseType.Isar:
        await _database.writeTxn(() async {
          await _database.put(data);
        });
        break;
      case DatabaseType.ObjectBox:
        _database.box<Map<String, dynamic>>().put(data);
        break;
      case DatabaseType.Sqflite:
        await _database.insert('storage', {'key': key, 'value': jsonEncode(data)},
            conflictAlgorithm: ConflictAlgorithm.replace);
        break;
      case DatabaseType.Drift:
        await _database.into(_database.storage).insertOnConflictUpdate(
            {'key': key, 'value': jsonEncode(data)});
        break;
      case DatabaseType.Realm:
        _database.write(() {
          _database.add(data);
        });
        break;
    }
  }

  @override
  Future<Map<String, dynamic>?> getData(String key) async {
    switch (databaseType) {
      case DatabaseType.Hive:
        return jsonDecode(_database.get(key));
      case DatabaseType.Isar:
        return await _database.get(key);
      case DatabaseType.ObjectBox:
        return _database.box<Map<String, dynamic>>().get(key);
      case DatabaseType.Sqflite:
        final result =
            await _database.query('SELECT value FROM storage WHERE key = ?',
                [key]);
        return result.isNotEmpty ? jsonDecode(result.first['value']) : null;
      case DatabaseType.Drift:
        final result = await _database.select(_database.storage)
            .where((tbl) => tbl.key.equals(key)).get();
        return result.isNotEmpty ? jsonDecode(result.first.value) : null;
      case DatabaseType.Realm:
        return _database.find(key);
    }
  }

  @override
  Future<void> deleteData(String key) async {
    switch (databaseType) {
      case DatabaseType.Hive:
        await _database.delete(key);
        break;
      case DatabaseType.Isar:
        await _database.writeTxn(() async {
          await _database.delete(key);
        });
        break;
      case DatabaseType.ObjectBox:
        _database.box<Map<String, dynamic>>().remove(key);
        break;
      case DatabaseType.Sqflite:
        await _database.delete('storage', where: 'key = ?', whereArgs: [key]);
        break;
      case DatabaseType.Drift:
        await (_database.delete(_database.storage)..where((tbl) => tbl.key.equals(key))).go();
        break;
      case DatabaseType.Realm:
        _database.write(() {
          _database.delete(key);
        });
        break;
    }
  }
}
