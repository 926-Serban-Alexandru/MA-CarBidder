import 'dart:ffi';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
       ManufacturerName TEXT,
       ModelName TEXT,
       PriceInitial INTEGER,
       ModelYear INTEGER,
       Color TEXT
    )""");
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
      "car_bidder.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      });
  }

  static Future<int> createData(
      String ManufacturerName,
      String ModelName,
      int PriceInitial,
      int ModelYear,
      String Color) async{
    final db = await SqlHelper.db();

    final data = {
      'ManufacturerName': ManufacturerName,
      'ModelName': ModelName,
      'PriceInitial': PriceInitial,
      'ModelYear': ModelYear,
      'String': Color};

    final id = await db.insert('data', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SqlHelper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SqlHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1 );

  }

  static Future<int> updateData(int? id, String ManufacturerName, String ModelName,
      int PriceInitial, int ModelYear, String Color) async {

    final db = await SqlHelper.db();
    final data  = {
      'ManufacturerName': ManufacturerName,
      'ModelName': ModelName,
      'PriceInitial': PriceInitial,
      'ModelYear': ModelYear,
      'Color': Color
    };

    final result = await db.update('data', data, where: "id = ?",
        whereArgs: [id]);

      return result;
    }

    static Future<void> deleteData(int id) async {
    final db = await SqlHelper.db();

    try {
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    } catch (e) {}
  }

}