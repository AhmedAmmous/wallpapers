class Favorites {
  final int? id;
  final int? imageId;

  final String? imageUrlOriginal;
  final String? imageUrlMedium;
  final String? imageAlt;

  Favorites(
      {this.id,
      this.imageId,
      this.imageUrlOriginal,
      this.imageUrlMedium,
      this.imageAlt});

  Favorites.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        imageId = res["imageId"],
        imageUrlOriginal = res["imageUrlOriginal"],
        imageUrlMedium = res["imageUrlMedium"],
        imageAlt = res["imageAlt"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'imageId': imageId,
      'imageUrlOriginal': imageUrlOriginal,
      'imageUrlMedium': imageUrlMedium,
      'imageAlt': imageAlt
    };
  }
}
