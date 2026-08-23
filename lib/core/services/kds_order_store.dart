import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/kds_order_model.dart';

class KdsOrderStore {
  KdsOrderStore._();

  static final instance = KdsOrderStore._();
  Database? _db;

  Future<void> init() async {
    final path = p.join(await getDatabasesPath(), 'softverse_kds.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE orders (
            id TEXT PRIMARY KEY,
            status TEXT NOT NULL,
            payload TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> upsert(KdsOrderModel order) async {
    await _database.insert('orders', {
      'id': order.id.isEmpty ? order.orderId : order.id,
      'status': order.status,
      'payload': jsonEncode(order.toJson()),
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> markCompleted(String id, {KdsOrderModel? fallback}) async {
    final key = id.trim();
    if (key.isEmpty) return;

    final rows = await _database.query(
      'orders',
      where: 'id = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) {
      if (fallback == null) return;
      await upsert(fallback);
    }

    final existing = await _database.query(
      'orders',
      where: 'id = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (existing.isEmpty) return;

    final payload =
        jsonDecode(existing.first['payload'] as String) as Map<String, dynamic>;
    payload['status'] = 'completed';
    payload['completedAt'] = DateTime.now().toIso8601String();
    await _database.update(
      'orders',
      {
        'status': 'completed',
        'payload': jsonEncode(payload),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [key],
    );
  }

  Future<List<KdsOrderModel>> listOpen() async {
    final rows = await _database.query(
      'orders',
      where: "LOWER(status) NOT IN ('completed', 'done', 'served')",
      orderBy: 'updated_at DESC',
    );

    return rows
        .map(
          (row) => KdsOrderModel.fromJson(
            jsonDecode(row['payload'] as String) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<KdsOrderModel>> listCompleted() async {
    final rows = await _database.query(
      'orders',
      where: "LOWER(status) IN ('completed', 'done', 'served')",
      orderBy: 'updated_at DESC',
    );

    return rows
        .map(
          (row) => KdsOrderModel.fromJson(
            jsonDecode(row['payload'] as String) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Database get _database {
    final db = _db;
    if (db == null) throw StateError('KDS database is not ready');
    return db;
  }
}
