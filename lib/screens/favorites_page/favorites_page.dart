import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/database_helper.dart';
import 'package:wallpaper/models/favorites.dart';
import 'package:wallpaper/widgets/favorites_item.dart';

class FavoritesPage extends StatelessWidget {
  final DatabaseHandler handler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: FutureBuilder(
        future: handler.retrieveFavorites(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Favorites>> snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 3,
              children: <Widget>[
                for (int index = 0; index < snapshot.data!.length; index++)
                  FavoritesItem(
                    imageUrlMedium:
                        snapshot.data!.elementAt(index).imageUrlMedium,
                    imageId: snapshot.data!.elementAt(index).imageId,
                    imageUrlOriginal:
                        snapshot.data!.elementAt(index).imageUrlOriginal,
                    imageAlt: snapshot.data!.elementAt(index).imageAlt,
                    id: snapshot.data!.elementAt(index).id,
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
