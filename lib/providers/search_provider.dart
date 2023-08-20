import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wallpaper/constant/url.dart';
import 'package:wallpaper/models/wallpaper.dart';

class SearchProvider extends ChangeNotifier {
  Wallpaper wallpapers = new Wallpaper();
  Wallpaper newWallpapers = new Wallpaper();
  List<Photos> photos = [];
  String nextUrl = "";
  bool loading = false;
  bool loadingMore = false;
  ScrollController controller = ScrollController();

  SearchProvider(BuildContext context) {
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent) {
        getNextWallpapers(context);
      }
    });
  }

  getSearchWallpapers(BuildContext context, String searchText) async {
    loading = true;
    notifyListeners();

    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection == true) {
      var url = "${URL.GeneralHost}${URL.SearchWallpapers}?query=${searchText}&per_page=${URL.PerPage}";
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': URL.Authorization,
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body) == null) {
        } else {
          wallpapers = Wallpaper.fromJson(jsonDecode(response.body));
          photos = wallpapers.photos!;
          nextUrl = wallpapers.nextPage??"";
          loading = false;
        }
      } else {
        SnackBar snackBar = SnackBar(
          content: Container(
            child: Text('Failed to load data'),
          ),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        loading = false;
      }
      notifyListeners();
    } else {
      SnackBar snackBar = SnackBar(
        content: Container(
          child: Text('No Internet Connection'),
        ),
        backgroundColor: Colors.redAccent,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      loading = false;
      notifyListeners();
    }
  }

  getNextWallpapers(BuildContext context) async {
    loadingMore = true;
    notifyListeners();

    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection == true) {
      var url = nextUrl;
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': URL.Authorization,
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body) == null) {
        } else {
          newWallpapers = Wallpaper.fromJson(jsonDecode(response.body));
          nextUrl = newWallpapers.nextPage!;
          photos += newWallpapers.photos!;
          loading = false;
          loadingMore = false;
        }
      } else {
        SnackBar snackBar = SnackBar(
          content: Container(
            child: Text('Failed to load data'),
          ),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        loading = false;
        loadingMore = false;
      }
      notifyListeners();
    } else {
      SnackBar snackBar = SnackBar(
        content: Container(
          child: Text('No Internet Connection'),
        ),
        backgroundColor: Colors.redAccent,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      loading = false;
      loadingMore = false;
      notifyListeners();
    }
  }
}
