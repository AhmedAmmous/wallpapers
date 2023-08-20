import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallpaper/models/favorites.dart';

class DatabaseHandler {
  List<Favorites> allFavoritesData = [];
  bool loadingFavorites = true;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, imageId INTEGER NOT NULL,imageUrlOriginal TEXT NOT NULL,imageUrlMedium TEXT NOT NULL,imageAlt TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertFavorites(List<Favorites> favorites) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in favorites) {
      result = await db.insert('favorites', user.toMap());
    }
    return result;
  }

  Future<List<Favorites>> retrieveFavorites() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('favorites');
    allFavoritesData = queryResult.map((e) => Favorites.fromMap(e)).toList();
    loadingFavorites = false;
    return queryResult.map((e) => Favorites.fromMap(e)).toList();
  }

  Future<void> deleteFavorites(int id) async {
    final db = await initializeDB();
    await db.delete(
      'favorites',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateFavorites(Favorites favorites) async {
    final db = await initializeDB();
    await db.update(
      "favorites",
      favorites.toMap(),
      where: "id = ?",
      whereArgs: [favorites.id],
    );
  }
}
