import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tdd_arc/tdd/data/model/repository_modle.dart';

enum DatabaseType { Hive, Isar, ObjectBox, Sqflite, Drift, Realm }

abstract class LocalDataSource {
  Future<void> saveData(String key, RepositoryModel data);
  Future<RepositoryModel?> getData(String key);
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
        _database = await openDatabase(
          'local.db',
          version: 1,
          onCreate: (db, version) {
            db.execute(
              'CREATE TABLE storage (key TEXT PRIMARY KEY, value TEXT)',
            );
          },
        );
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
  Future<void> saveData(String key, RepositoryModel data) async {
    switch (databaseType) {
      case DatabaseType.Hive:
        if ((_database as Box<dynamic>).containsKey(key)) {
          deleteData(key);
        }
        await _database.put(key, data.toJson());
        break;
      case DatabaseType.Isar:
        await _database.writeTxn(() async {
          await _database.put(data);
        });
        break;
      case DatabaseType.ObjectBox:
        _database.box<RepositoryModel>().put(data);
        break;
      case DatabaseType.Sqflite:
        await _database.insert('storage', {
          'key': key,
          'value': data.toJson(),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
        break;
      case DatabaseType.Drift:
        await _database.into(_database.storage).insertOnConflictUpdate({
          'key': key,
          'value': data.toJson(),
        });
        break;
      case DatabaseType.Realm:
        _database.write(() {
          _database.add(data.toJson());
        });
        break;
    }
  }

  @override
  Future<RepositoryModel?> getData(String key) async {
    switch (databaseType) {
      case DatabaseType.Hive:
        return RepositoryModel.fromJson((_database as Box<dynamic>).get(key));
      case DatabaseType.Isar:
        return await _database.get(key);
      case DatabaseType.ObjectBox:
        return _database.box<RepositoryModel>().get(key);
      case DatabaseType.Sqflite:
        final result = await _database.query(
          'SELECT value FROM storage WHERE key = ?',
          [key],
        );
        return result.isNotEmpty
            ? RepositoryModel.fromJson(result.first['value'])
            : null;
      case DatabaseType.Drift:
        final result =
            await _database
                .select(_database.storage)
                .where((tbl) => tbl.key.equals(key))
                .get();
        return result.isNotEmpty
            ? RepositoryModel.fromJson(result.first.value)
            : null;
      case DatabaseType.Realm:
        return RepositoryModel.fromJson(_database.find(key));
    }
  }

  @override
  Future<void> deleteData(String key) async {
    switch (databaseType) {
      case DatabaseType.Hive:
        await (_database as Box<dynamic>).delete(key);
        break;
      case DatabaseType.Isar:
        await _database.writeTxn(() async {
          await _database.delete(key);
        });
        break;
      case DatabaseType.ObjectBox:
        _database.box<RepositoryModel>().remove(key);
        break;
      case DatabaseType.Sqflite:
        await _database.delete('storage', where: 'key = ?', whereArgs: [key]);
        break;
      case DatabaseType.Drift:
        await (_database.delete(_database.storage)
          ..where((tbl) => tbl.key.equals(key))).go();
        break;
      case DatabaseType.Realm:
        _database.write(() {
          _database.delete(key);
        });
        break;
    }
  }


}
