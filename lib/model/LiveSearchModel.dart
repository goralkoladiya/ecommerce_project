// To parse this JSON data, do
//
//     final liveSearchModel = liveSearchModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazy_app/model/Category/CategoryData.dart';
import 'package:amazy_app/model/Tags/TagData.dart';

LiveSearchModel liveSearchModelFromJson(String str) =>
    LiveSearchModel.fromJson(json.decode(str));

String liveSearchModelToJson(LiveSearchModel data) =>
    json.encode(data.toJson());

class LiveSearchModel {
  LiveSearchModel({
    this.tags,
    this.products,
    this.categories,
  });

  List<TagData> tags;
  List<SearchedProductModel> products;
  List<CategoryData> categories;

  factory LiveSearchModel.fromJson(Map<String, dynamic> json) =>
      LiveSearchModel(
        tags: List<TagData>.from(json["tags"].map((x) => TagData.fromJson(x))),
        products: List<SearchedProductModel>.from(
            json["products"].map((x) => SearchedProductModel.fromJson(x))),
        categories: List<CategoryData>.from(
            json["categories"].map((x) => CategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class SearchedProductModel {
    SearchedProductModel({
      this.id,
        this.productName,
        this.thumbImg,
        this.sellingPrice,
        this.hasDiscount,
        this.discountPrice,
        this.stock,
        this.url,
    });

    int id;
    String productName;
    String thumbImg;
    double sellingPrice;
    int hasDiscount;
    double discountPrice;
    int stock;
    String url;

    factory SearchedProductModel.fromJson(Map<String, dynamic> json) => SearchedProductModel(
        id: json["id"],
        productName: json["product_name"],
        thumbImg: json["thumb_img"],
        sellingPrice: json["selling_price"].toDouble(),
        hasDiscount: json["hasDiscount"],
        discountPrice: json["discount_price"].toDouble(),
        stock: json["stock"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "thumb_img": thumbImg,
        "selling_price": sellingPrice,
        "hasDiscount": hasDiscount,
        "discount_price": discountPrice,
        "stock": stock,
        "url": url,
    };
}
