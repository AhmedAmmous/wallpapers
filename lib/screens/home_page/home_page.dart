import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/screens/favorites_page/favorites_page.dart';
import 'package:wallpaper/screens/search_page/search_page.dart';
import 'package:wallpaper/widgets/shimmer_widget.dart';
import 'package:wallpaper/widgets/wallpaper_item.dart';

import '../../providers/home_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wallpaper"), actions: [
        const SizedBox(
          width: 20,
        ),
        InkWell(
          child: const Icon(Icons.favorite),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FavoritesPage()));
          },
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          child: const Icon(Icons.search),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SearchPage()));
          },
        ),
        const SizedBox(
          width: 20,
        ),
      ]),
      body: ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(context),
        child: Consumer<HomeProvider>(
          builder: (_, provider, __) => Scaffold(
            body: provider.loading == true
                ? ShimmerWidget()
                : GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 3,
                    controller: provider.controller,
                    children: <Widget>[
                      for (int index = 0;
                          index < provider.photos.length;
                          index++)
                        WallpaperItem(
                          photo: provider.photos.elementAt(index),
                        ),
                      provider.loadingMore
                          ? ShimmerWidget()
                          : const SizedBox.shrink()
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
