import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/models/wallpaper.dart';
import 'package:wallpaper/screens/wallpaper_page/wallpaper_page.dart';

class WallpaperItem extends StatelessWidget {
  Photos photo;

  WallpaperItem({required this.photo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0,
          ),
        ),
        child: Image.network(photo.src!.medium!),
      ),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => WallpaperPage(
              photo: photo,
            ),
          ),
        );

      },
    );
  }
}
