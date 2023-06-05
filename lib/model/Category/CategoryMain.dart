import 'dart:convert';

import 'CategoryData.dart';

CategoryMain categoryFromJson(String str) =>
    CategoryMain.fromJson(json.decode(str));

String categoryToJson(CategoryMain data) => json.encode(data.toJson());

class CategoryMain {
  CategoryMain({
    this.data,
    this.msg,
  });

  CategoryPaginatedData data;
  String msg;

  factory CategoryMain.fromJson(Map<String, dynamic> json) => CategoryMain(
        data: CategoryPaginatedData.fromJson(json["data"]),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "msg": msg,
      };
}

class CategoryPaginatedData {
  CategoryPaginatedData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<CategoryData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory CategoryPaginatedData.fromJson(Map<String, dynamic> json) => CategoryPaginatedData(
        currentPage: json["current_page"],
        data: List<CategoryData>.from(
            json["data"].map((x) => CategoryData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}
