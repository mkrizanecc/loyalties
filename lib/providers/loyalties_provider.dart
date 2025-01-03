import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:loyalties/models/loyalty.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'loyalties.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE loyalties(id STRING PRIMARY KEY, store VARCHAR(50), image TEXT)');
    },
  );
  return db;
}

class LoyaltiesNotifier extends StateNotifier<List<Loyalty>> {
  LoyaltiesNotifier() : super([]);

  void loadLoyalties() async {
    final connection = await _getDatabase();

    final loyalties = await connection.query('loyalties');
    final convertedLoyalties = loyalties.map((loyalty) {
      return Loyalty(
        id: loyalty['id'] as String,
        store: loyalty['store'] as String,
        image: File(loyalty['image'] as String),
      );
    }).toList();

    state = convertedLoyalties;
  }

  void newLoyalty(Loyalty loyalty) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(loyalty.image.path);
    final copiedImage = await loyalty.image.copy('${appDir.path}/$filename');

    final newLoyalty = Loyalty(
      store: loyalty.store,
      image: copiedImage,
    );

    final db = await _getDatabase();

    db.insert('loyalties', newLoyalty.toMap());

    state = [...state, newLoyalty];
  }

  void removeLoyalty(String id) async {
    final db = await _getDatabase();

    db.delete('loyalties', where: 'id = ?', whereArgs: [id]);

    final loyalties = state.where((loyalty) => loyalty.id != id).toList();

    state = loyalties;
  }
}

final loyaltiesProvider =
    StateNotifierProvider<LoyaltiesNotifier, List<Loyalty>>((ref) {
  return LoyaltiesNotifier();
});
