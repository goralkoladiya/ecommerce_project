// To parse this JSON data, do
//
//     final couponApplyModel = couponApplyModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazy_app/model/Product/ProductModel.dart';

CouponApplyModel couponApplyModelFromJson(String str) =>
    CouponApplyModel.fromJson(json.decode(str));

String couponApplyModelToJson(CouponApplyModel data) =>
    json.encode(data.toJson());

class CouponApplyModel {
  CouponApplyModel({
    this.coupon,
    this.message,
  });

  Coupon coupon;
  String message;

  factory CouponApplyModel.fromJson(Map<String, dynamic> json) =>
      CouponApplyModel(
        coupon: Coupon.fromJson(json["coupon"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "coupon": coupon.toJson(),
        "message": message,
      };
}

class Coupon {
  Coupon({
    this.id,
    this.title,
    this.couponCode,
    this.couponType,
    this.startDate,
    this.endDate,
    this.discount,
    this.discountType,
    this.minimumShopping,
    this.maximumDiscount,
    this.isExpire,
    this.isMultipleBuy,
    this.products,
  });

  int id;
  String title;
  String couponCode;
  int couponType;
  DateTime startDate;
  DateTime endDate;
  double discount;
  int discountType;
  int minimumShopping;
  double maximumDiscount;
  int isExpire;
  int isMultipleBuy;
  List<ProductElement> products;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        title: json["title"],
        couponCode: json["coupon_code"],
        couponType: json["coupon_type"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        discount: double.parse(json["discount"].toString()),
        discountType: json["discount_type"],
        minimumShopping: json["minimum_shopping"],
        maximumDiscount: json["maximum_discount"],
        isExpire: json["is_expire"],
        isMultipleBuy: json["is_multiple_buy"],
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "coupon_code": couponCode,
        "coupon_type": couponType,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "discount": discount,
        "discount_type": discountType,
        "minimum_shopping": minimumShopping,
        "maximum_discount": maximumDiscount,
        "is_expire": isExpire,
        "is_multiple_buy": isMultipleBuy,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductElement {
  ProductElement({
    this.id,
    this.couponId,
    this.couponCode,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  dynamic id;
  dynamic couponId;
  String couponCode;
  dynamic productId;
  DateTime createdAt;
  DateTime updatedAt;
  ProductModel product;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        id: json["id"],
        couponId: json["coupon_id"],
        couponCode: json["coupon_code"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_id": couponId,
        "coupon_code": couponCode,
        "product_id": productId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
      };
}
