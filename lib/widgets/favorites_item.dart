import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'package:wallpaper/screens/wallpaper_page/favorites_wallpaper_page.dart';
import 'package:wallpaper/screens/wallpaper_page/wallpaper_page.dart';

class FavoritesItem extends StatelessWidget {
  final int? id;
  final int? imageId;

  final String? imageUrlOriginal;
  final String? imageUrlMedium;
  final String? imageAlt;

  FavoritesItem(
      {required this.id,
      required this.imageId,
      required this.imageAlt,
      required this.imageUrlMedium,
      required this.imageUrlOriginal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0,
          ),
        ),
        child: Image.network(imageUrlMedium!),
      ),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => FavoritesWallpaperPage(
              id: id,
              imageAlt: imageAlt,
              imageId: imageId,
              imageUrlMedium: imageUrlMedium,
              imageUrlOriginal: imageUrlOriginal,
            ),
          ),
        );
      },
    );
  }
}
