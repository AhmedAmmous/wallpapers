import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wallpaper/database_helper.dart';
import 'package:wallpaper/models/favorites.dart';
import 'package:wallpaper/models/wallpaper.dart';

class WallpaperPage extends StatelessWidget {
  Photos photo;
  final DatabaseHandler handler = DatabaseHandler();

  WallpaperPage({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black87,
          child: Image.network(
            photo.src!.original!,
            width: double.parse(photo.width.toString()),
            height: double.parse(photo.height.toString()),
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
                  await addFav(photo.id!, photo.alt!, photo.src!.medium!,
                      photo.src!.original!);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Image Added To Favorites'),
                    backgroundColor: Colors.greenAccent,
                  ));
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
                  var response = await Dio().get(photo.src!.original!,
                      options: Options(responseType: ResponseType.bytes));
                  final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(response.data),
                      name: photo.alt);
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

  Future<int> addFav(int imageId, String imageAlt, String imageUrlMedium,
      String imageUrlOriginal) async {
    Favorites fav = Favorites(
        imageId: photo.id,
        imageAlt: photo.alt,
        imageUrlMedium: photo.src!.medium,
        imageUrlOriginal: photo.src!.original);
    List<Favorites> listOfFav = [fav];
    return await handler.insertFavorites(listOfFav);
  }
}
