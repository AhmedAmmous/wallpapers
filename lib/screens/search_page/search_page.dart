import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/providers/search_provider.dart';
import 'package:wallpaper/widgets/wallpaper_item.dart';

import '../../widgets/shimmer_widget.dart';

class SearchPage extends StatelessWidget {
  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: ChangeNotifierProvider<SearchProvider>(
        create: (_) => SearchProvider(context),
        child: Consumer<SearchProvider>(
          builder: (_, provider, __) => Scaffold(
            body: Column(
              children: [
            TextField(
              controller: txtSearch,
              onSubmitted: (val) {
                provider.getSearchWallpapers(context, val);
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () {
                    provider.getSearchWallpapers(context, txtSearch.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            provider.loading == true
                ? Expanded(child: ShimmerWidget())
                : provider.photos.isNotEmpty
                    ? Expanded(
                        child: GridView.count(
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
                      )
                    : const Center(child: Text("No Results For Your Search")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
