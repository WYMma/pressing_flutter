import 'package:laundry/model/LSCartModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LSDBHelper {
  Future<Database> initializeDB() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    return openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE cart(id INTEGER PRIMARY KEY AUTOINCREMENT, productId TEXT, productName TEXT, initialPrice REAL, productPrice REAL, quantity INTEGER, unitTag TEXT, image TEXT)",
        );
      },
      version: 1,
    );
  }
  Future<void> insertItem(LSCartModel item) async {
    final db = await initializeDB();
    var res = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [item.productId],
    );
    if (res.isNotEmpty) {
      int newQuantity = (res.first['quantity'] as int) + 1;
      await db.update(
        'cart',
        {'quantity': newQuantity},
        where: 'productId = ?',
        whereArgs: [item.productId],
      );
    } else {
      await db.insert('cart', item.toMap());
    }
  }

  Future<List<LSCartModel>> getCartItems() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('cart');
    return queryResult.map((e) => LSCartModel.fromMap(e)).toList();
  }

  Future<void> updateItem(LSCartModel item) async {
    final db = await initializeDB();
    await db.update('cart', item.toMap(), where: "id = ?", whereArgs: [item.id]);
  }

  Future<void> deleteItem(int id) async {
    final db = await initializeDB();
    await db.delete('cart', where: "id = ?", whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final db = await initializeDB();
    await db.delete('cart');
  }

}
