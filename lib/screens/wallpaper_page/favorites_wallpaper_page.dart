import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wallpaper/database_helper.dart';
import 'package:wallpaper/models/favorites.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'package:wallpaper/screens/favorites_page/favorites_page.dart';

class FavoritesWallpaperPage extends StatelessWidget {
  final int? id;
  final int? imageId;

  final String? imageUrlOriginal;
  final String? imageUrlMedium;
  final String? imageAlt;

  FavoritesWallpaperPage(
      {required this.id,
      required this.imageId,
      required this.imageAlt,
      required this.imageUrlMedium,
      required this.imageUrlOriginal});

  final DatabaseHandler handler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black87,
          child: Image.network(
            imageUrlOriginal!,
            width: 1000,
            height: 1000,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: Shimmer(
                  duration: const Duration(seconds: 1),
                  interval: const Duration(seconds: 2),
                  color: Colors.black,
                  enabled: true,
                  direction: const ShimmerDirection.fromLTRB(),
                  child: Container(
                    width: 450,
                    height: 450,
                    color: const Color(0xFFDEDEDE),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 30,
          left: 20,
          child: FloatingActionButton(
            heroTag: "back",
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 60,
          child: SizedBox(
            width: 70,
            height: 70,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "fav",
                onPressed: () async {
                  await handler.deleteFavorites(id!);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => FavoritesPage()));
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.favorite,
                  size: 30,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          right: 60,
          child: SizedBox(
            width: 70,
            height: 70,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "download",
                onPressed: () async {
                  var response = await Dio().get(imageUrlOriginal!,
                      options: Options(responseType: ResponseType.bytes));
                  final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(response.data),
                      name: imageAlt!);
                  if (result["isSuccess"]) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Image Downloaded successfully'),
                      backgroundColor: Colors.greenAccent,
                    ));
                  }
                },
                backgroundColor: Colors.blueAccent,
                child: const Icon(
                  Icons.download,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
