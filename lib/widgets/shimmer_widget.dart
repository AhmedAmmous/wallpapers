import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wallpaper/models/wallpaper.dart';

class ShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      crossAxisCount: 3,
      children: <Widget>[
        for (int index = 0; index < 30; index++)
          Shimmer(
            duration: const Duration(seconds: 3),
            interval: const Duration(seconds: 5),
            color: Colors.black,
            colorOpacity: 0,
            enabled: true,
            direction: const ShimmerDirection.fromLTRB(),
            child: Container(
              color: const Color(0xFFDEDEDE),
            ),
          ),
      ],
    );
  }
}
