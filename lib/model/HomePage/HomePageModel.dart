// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazy_app/model/Product/ProductModel.dart';

HomePageModel homePageModelFromJson(String str) =>
    HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
  HomePageModel({
    this.topCategories,
    this.featuredBrands,
    this.sliders,
    this.newUserZone,
    this.flashDeal,
    this.topPicks,
    this.msg,
  });

  List<CategoryBrand> topCategories;
  List<CategoryBrand> featuredBrands;
  List<HomePageSlider> sliders;
  NewUserZone newUserZone;
  HomePageModelFlashDeal flashDeal;
  List<ProductModel> topPicks;
  String msg;

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
        topCategories: List<CategoryBrand>.from(
            json["top_categories"].map((x) => CategoryBrand.fromJson(x))),
        featuredBrands: List<CategoryBrand>.from(
            json["featured_brands"].map((x) => CategoryBrand.fromJson(x))),
        sliders: List<HomePageSlider>.from(
            json["sliders"].map((x) => HomePageSlider.fromJson(x))),
        newUserZone: json["new_user_zone"] == null
            ? null
            : NewUserZone.fromJson(json["new_user_zone"]),
        flashDeal: json["flash_deal"] == null
            ? null
            : HomePageModelFlashDeal.fromJson(json["flash_deal"]),
        topPicks: List<ProductModel>.from(
            json["top_picks"].map((x) => ProductModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "top_categories":
            List<dynamic>.from(topCategories.map((x) => x.toJson())),
        "featured_brands":
            List<dynamic>.from(featuredBrands.map((x) => x.toJson())),
        "sliders": List<dynamic>.from(sliders.map((x) => x.toJson())),
        "new_user_zone": newUserZone == null ? null : newUserZone.toJson(),
        "flash_deal": flashDeal == null ? null : flashDeal.toJson(),
        "top_picks": List<dynamic>.from(topPicks.map((x) => x.toJson())),
        "msg": msg,
      };
}

class CategoryBrand {
  CategoryBrand({
    this.id,
    this.name,
    this.logo,
    this.slug,
    this.icon,
    this.image,
  });

  int id;
  String name;
  String logo;
  String slug;
  String icon;
  String image;

  factory CategoryBrand.fromJson(Map<String, dynamic> json) => CategoryBrand(
        id: json["id"],
        name: json["name"],
        logo: json["logo"] == null ? null : json["logo"],
        slug: json["slug"] == null ? null : json["slug"],
        icon: json["icon"] == null ? null : json["icon"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo == null ? null : logo,
        "slug": slug == null ? null : slug,
        "icon": icon == null ? null : icon,
        "image": image == null ? null : image,
      };
}

class HomePageModelFlashDeal {
  HomePageModelFlashDeal({
    this.id,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.startDate,
    this.endDate,
    this.slug,
    this.bannerImage,
    this.isFeatured,
    this.allProducts,
  });

  int id;
  String title;
  String backgroundColor;
  String textColor;
  DateTime startDate;
  DateTime endDate;
  String slug;
  String bannerImage;
  int isFeatured;
  List<FlashDealAllProduct> allProducts;

  factory HomePageModelFlashDeal.fromJson(Map<String, dynamic> json) =>
      HomePageModelFlashDeal(
        id: json["id"],
        title: json["title"],
        backgroundColor: json["background_color"],
        textColor: json["text_color"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        slug: json["slug"],
        bannerImage: json["banner_image"],
        isFeatured: json["is_featured"],
        allProducts: List<FlashDealAllProduct>.from(
            json["AllProducts"].map((x) => FlashDealAllProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "background_color": backgroundColor,
        "text_color": textColor,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "slug": slug,
        "banner_image": bannerImage,
        "is_featured": isFeatured,
        "AllProducts": List<dynamic>.from(allProducts.map((x) => x.toJson())),
      };
}

class FlashDealAllProduct {
  FlashDealAllProduct({
    this.id,
    this.flashDealId,
    this.sellerProductId,
    this.discount,
    this.discountType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  int id;
  int flashDealId;
  int sellerProductId;
  int discount;
  int discountType;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  ProductModel product;

  factory FlashDealAllProduct.fromJson(Map<double, dynamic> json) =>
      FlashDealAllProduct(
        id: json["id"],
        flashDealId: json["flash_deal_id"],
        sellerProductId: json["seller_product_id"],
        discount: json["discount"],
        discountType: json["discount_type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "flash_deal_id": flashDealId,
        "seller_product_id": sellerProductId,
        "discount": discount,
        "discount_type": discountType,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product == null ? null : product.toJson(),
      };
}

class NewUserZone {
  NewUserZone({
    this.id,
    this.title,
    this.backgroundColor,
    this.slug,
    this.bannerImage,
    this.productNavigationLabel,
    this.categoryNavigationLabel,
    this.couponNavigationLabel,
    this.productSlogan,
    this.categorySlogan,
    this.couponSlogan,
    this.coupon,
    this.allProducts,
  });

  int id;
  String title;
  String backgroundColor;
  String slug;
  String bannerImage;
  String productNavigationLabel;
  String categoryNavigationLabel;
  String couponNavigationLabel;
  String productSlogan;
  String categorySlogan;
  String couponSlogan;
  Coupon coupon;
  List<NewUserZoneAllProduct> allProducts;

  factory NewUserZone.fromJson(Map<String, dynamic> json) => NewUserZone(
        id: json["id"],
        title: json["title"],
        backgroundColor: json["background_color"],
        slug: json["slug"],
        bannerImage: json["banner_image"],
        productNavigationLabel: json["product_navigation_label"],
        categoryNavigationLabel: json["category_navigation_label"],
        couponNavigationLabel: json["coupon_navigation_label"],
        productSlogan: json["product_slogan"],
        categorySlogan: json["category_slogan"],
        couponSlogan: json["coupon_slogan"],
        coupon: Coupon.fromJson(json["coupon"]),
        allProducts: List<NewUserZoneAllProduct>.from(
          json["AllProducts"].map(
            (x) {
              if(x["product"]==null){
                print('nullllllllllll');
                return null;
              }
              return NewUserZoneAllProduct.fromJson(x);
            },
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "background_color": backgroundColor,
        "slug": slug,
        "banner_image": bannerImage,
        "product_navigation_label": productNavigationLabel,
        "category_navigation_label": categoryNavigationLabel,
        "coupon_navigation_label": couponNavigationLabel,
        "product_slogan": productSlogan,
        "category_slogan": categorySlogan,
        "coupon_slogan": couponSlogan,
        "coupon": coupon.toJson(),
        "AllProducts": List<dynamic>.from(allProducts.map((x) => x.toJson())),
      };
}

class NewUserZoneAllProduct {
  NewUserZoneAllProduct({
    this.id,
    this.newUserZoneId,
    this.sellerProductId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  int id;
  int newUserZoneId;
  int sellerProductId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  ProductModel product;

  factory NewUserZoneAllProduct.fromJson(Map<String, dynamic> json) =>
      NewUserZoneAllProduct(
        id: json["id"],
        newUserZoneId: json["new_user_zone_id"],
        sellerProductId: json["seller_product_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: json["product"] == null
            ? ProductModel.fromJson({
                "id": 76,
                "user_id": 1,
                "product_id": 80,
                "tax": 2,
                "tax_type": "0",
                "discount": 5,
                "discount_type": "0",
                "discount_start_date": null,
                "discount_end_date": null,
                "product_name":
                    "Beautiful Three Seated Sofa - Clean & Minimal Design",
                "slug": "beautiful-three-seated-sofa---clean-&-minimal-design",
                "thum_img": null,
                "status": 1,
                "stock_manage": 0,
                "is_approved": 1,
                "min_sell_price": 0,
                "max_sell_price": 0,
                "total_sale": 1,
                "avg_rating": 0,
                "recent_view": "2023-03-16 06:16:13",
                "subtitle_1": null,
                "subtitle_2": null,
                "created_at": "2021-11-24T10:29:41.000000Z",
                "updated_at": "2023-03-16T00:16:13.000000Z",
                "variantDetails": [
                  {
                    "value": ["Gray", "Blue", "Purple"],
                    "code": ["#999999", "#258cd9", "#6728a3"],
                    "attr_val_id": [6, 7, 33],
                    "name": "Color",
                    "attr_id": 1
                  }
                ],
                "MaxSellingPrice": 0,
                "hasDeal": 0,
                "rating": 0,
                "hasDiscount": "yes",
                "ProductType": "product",
                "flash_deal": null,
                "product": {
                  "id": 80,
                  "product_name":
                      "Beautiful Three Seated Sofa - Clean & Minimal Design",
                  "product_type": 2,
                  "unit_type_id": 1,
                  "brand_id": 7,
                  "thumbnail_image_source":
                      "uploads/images/14-12-2022/6399c876defe6.jpeg",
                  "media_ids": "213,210,211,212",
                  "barcode_type": "C39",
                  "model_number": "sofa-0099",
                  "shipping_type": 0,
                  "shipping_cost": 0,
                  "discount_type": "0",
                  "discount": 5,
                  "tax_type": "0",
                  "gst_group_id": null,
                  "tax": 2,
                  "pdf": null,
                  "video_provider": "youtube",
                  "video_link": null,
                  "description":
                      "<h2 class=\"pdp-mod-section-title outer-title\" data-spm-anchor-id=\"a2a0e.pdp.0.i1.34deJ0NIJ0NIiP\" style=\"margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding: 0px 24px; font-weight: 500; font-family: Roboto-Medium; font-size: 16px; line-height: 52px; color: rgb(33, 33, 33); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; height: 52px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;\">Product details of Single Seater Arm Sofa</h2><div class=\"pdp-product-detail\" data-spm=\"product_detail\" style=\"margin: 0px; padding: 0px; position: relative; font-family: Roboto, -apple-system, BlinkMacSystemFont, &quot;Helvetica Neue&quot;, Helvetica, sans-serif; font-size: 12px; background-color: rgb(255, 255, 255);\"><div class=\"pdp-product-desc \" style=\"margin: 0px; padding: 5px 14px 5px 24px; height: auto; overflow-y: hidden;\"><div class=\"html-content pdp-product-highlights\" style=\"margin: 0px; padding: 11px 0px 16px; word-break: break-word; border-bottom: 1px solid rgb(239, 240, 245); overflow: hidden;\"><ul class=\"\" style=\"list-style: none; overflow: hidden; columns: auto 2; column-gap: 32px;\"><li class=\"\" style=\"margin: 0px; padding: 0px 0px 0px 15px; position: relative; font-size: 14px; line-height: 18px; text-align: left; word-break: break-word; break-inside: avoid;\">eye-catchy color and distinct design make it classy and comfortable to rest on</li><li class=\"\" style=\"margin: 0px; padding: 0px 0px 0px 15px; position: relative; font-size: 14px; line-height: 18px; text-align: left; word-break: break-word; break-inside: avoid;\">sleek and glossy look enhance the beauty of your living room</li><li class=\"\" style=\"margin: 0px; padding: 0px 0px 0px 15px; position: relative; font-size: 14px; line-height: 18px; text-align: left; word-break: break-word; break-inside: avoid;\">ensures good posture</li><li class=\"\" data-spm-anchor-id=\"a2a0e.pdp.product_detail.i0.34deJ0NIJ0NIiP\" style=\"margin: 0px; padding: 0px 0px 0px 15px; position: relative; font-size: 14px; line-height: 18px; text-align: left; word-break: break-word; break-inside: avoid;\">robust frame wrapped in high quality upholstery indemnifies durability up to 10-12 years if not pierced with sharp objects</li></ul></div><div class=\"html-content detail-content\" style=\"margin: 16px 0px 0px; padding: 0px 0px 16px; word-break: break-word; position: relative; height: auto; line-height: 19px; overflow-y: hidden; border-bottom: 1px solid rgb(239, 240, 245);\"><p style=\"margin-right: 0px; margin-left: 0px; padding: 8px 0px; font-family: none; white-space: pre-wrap;\"></p><div style=\"margin: 0px; padding: 8px 0px; white-space: pre-wrap;\"><div data-spm-anchor-id=\"a2a0e.pdp.product_detail.i5.34deJ0NIJ0NIiP\" style=\"margin: 0px; padding: 8px 0px;\"><span style=\"margin: 0px; padding: 0px; font-family: none;\">Material : solid wood (mehgani), plywood, foam, synthetic leather</span></div></div></div></div></div>",
                  "specification":
                      "<p><span class=\"key-title\" data-spm-anchor-id=\"a2a0e.pdp.product_detail.i3.34deJ0NIJ0NIiP\" style=\"margin: 0px; padding: 0px; display: table-cell; width: 140px; color: rgb(117, 117, 117); word-break: break-word; font-family: Roboto, -apple-system, BlinkMacSystemFont, &quot;Helvetica Neue&quot;, Helvetica, sans-serif; background-color: rgb(255, 255, 255);\">What’s in the box</span></p><div class=\"html-content box-content-html\" data-spm-anchor-id=\"a2a0e.pdp.product_detail.i4.34deJ0NIJ0NIiP\" style=\"margin: 0px; padding: 0px 0px 0px 18px; word-break: break-word; display: table-cell; font-family: Roboto, -apple-system, BlinkMacSystemFont, &quot;Helvetica Neue&quot;, Helvetica, sans-serif; font-size: 14px; background-color: rgb(255, 255, 255);\">Single Seater Arm Sofa</div>",
                  "minimum_order_qty": 1,
                  "max_order_qty": 10,
                  "meta_title": null,
                  "meta_description": null,
                  "meta_image": null,
                  "is_physical": 1,
                  "is_approved": 1,
                  "status": 1,
                  "club_point": "0",
                  "club_point_type": "0",
                  "display_in_details": 2,
                  "requested_by": 1,
                  "created_by": 1,
                  "slug": "beautiful-single-size-sofa-0099",
                  "stock_manage": 0,
                  "subtitle_1": null,
                  "subtitle_2": null,
                  "updated_by": 1,
                  "created_at": "2021-11-24T10:29:41.000000Z",
                  "updated_at": "2022-12-14T14:03:44.000000Z"
                },
                "skus": [
                  {
                    "id": 186,
                    "user_id": 1,
                    "product_id": 76,
                    "product_sku_id": "161",
                    "product_stock": 0,
                    "purchase_price": 0,
                    "selling_price": 0,
                    "status": 1,
                    "created_at": "2021-11-24T10:29:41.000000Z",
                    "updated_at": "2022-12-14T14:03:44.000000Z",
                    "product_variations": [
                      {
                        "id": 146,
                        "product_id": 80,
                        "product_sku_id": 161,
                        "attribute_id": 1,
                        "attribute_value_id": 6,
                        "created_by": null,
                        "updated_by": null,
                        "created_at": "2021-11-24T10:29:41.000000Z",
                        "updated_at": "2021-11-24T10:29:41.000000Z",
                        "attribute_value": {
                          "id": 6,
                          "value": "#999999",
                          "attribute_id": 1,
                          "created_at": "2021-09-26T05:44:20.000000Z",
                          "updated_at": "2021-09-26T05:44:20.000000Z",
                          "color": {
                            "id": 6,
                            "attribute_value_id": 6,
                            "name": "Gray",
                            "created_at": "2021-09-26T05:44:20.000000Z",
                            "updated_at": "2021-09-26T05:44:20.000000Z"
                          }
                        },
                        "attribute": {
                          "id": 1,
                          "name": "Color",
                          "display_type": "radio_button",
                          "description": "Color",
                          "status": 1,
                          "created_by": null,
                          "updated_by": 1,
                          "created_at": "2018-11-04T20:12:26.000000Z",
                          "updated_at": "2022-07-29T06:07:52.000000Z"
                        }
                      }
                    ]
                  },
                  {
                    "id": 187,
                    "user_id": 1,
                    "product_id": 76,
                    "product_sku_id": "162",
                    "product_stock": 0,
                    "purchase_price": 0,
                    "selling_price": 0,
                    "status": 1,
                    "created_at": "2021-11-24T10:29:41.000000Z",
                    "updated_at": "2022-12-14T14:03:44.000000Z",
                    "product_variations": [
                      {
                        "id": 147,
                        "product_id": 80,
                        "product_sku_id": 162,
                        "attribute_id": 1,
                        "attribute_value_id": 7,
                        "created_by": null,
                        "updated_by": null,
                        "created_at": "2021-11-24T10:29:41.000000Z",
                        "updated_at": "2021-11-24T10:29:41.000000Z",
                        "attribute": {
                          "id": 1,
                          "name": "Color",
                          "display_type": "radio_button",
                          "description": "Color",
                          "status": 1,
                          "created_by": null,
                          "updated_by": 1,
                          "created_at": "2018-11-04T20:12:26.000000Z",
                          "updated_at": "2022-07-29T06:07:52.000000Z"
                        },
                        "attribute_value": {
                          "id": 7,
                          "value": "#258cd9",
                          "attribute_id": 1,
                          "created_at": "2021-09-26T05:44:20.000000Z",
                          "updated_at": "2021-09-26T05:44:20.000000Z",
                          "color": {
                            "id": 7,
                            "attribute_value_id": 7,
                            "name": "Blue",
                            "created_at": "2021-09-26T05:44:20.000000Z",
                            "updated_at": "2021-09-26T05:44:20.000000Z"
                          }
                        }
                      }
                    ]
                  },
                  {
                    "id": 188,
                    "user_id": 1,
                    "product_id": 76,
                    "product_sku_id": "163",
                    "product_stock": 0,
                    "purchase_price": 0,
                    "selling_price": 0,
                    "status": 1,
                    "created_at": "2021-11-24T10:29:41.000000Z",
                    "updated_at": "2022-12-14T14:03:44.000000Z",
                    "product_variations": [
                      {
                        "id": 148,
                        "product_id": 80,
                        "product_sku_id": 163,
                        "attribute_id": 1,
                        "attribute_value_id": 33,
                        "created_by": null,
                        "updated_by": null,
                        "created_at": "2021-11-24T10:29:41.000000Z",
                        "updated_at": "2021-11-24T10:29:41.000000Z",
                        "attribute": {
                          "id": 1,
                          "name": "Color",
                          "display_type": "radio_button",
                          "description": "Color",
                          "status": 1,
                          "created_by": null,
                          "updated_by": 1,
                          "created_at": "2018-11-04T20:12:26.000000Z",
                          "updated_at": "2022-07-29T06:07:52.000000Z"
                        },
                        "attribute_value": {
                          "id": 33,
                          "value": "#6728a3",
                          "attribute_id": 1,
                          "created_at": "2021-09-28T04:09:06.000000Z",
                          "updated_at": "2021-09-28T04:09:06.000000Z",
                          "color": {
                            "id": 10,
                            "attribute_value_id": 33,
                            "name": "Purple",
                            "created_at": "2021-09-28T04:09:06.000000Z",
                            "updated_at": "2021-09-28T04:09:06.000000Z"
                          }
                        }
                      }
                    ]
                  }
                ],
                "reviews": []
              })
            : ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "new_user_zone_id": newUserZoneId,
        "seller_product_id": sellerProductId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
      };
}

class Coupon {
  Coupon({
    this.id,
    this.title,
    this.couponCode,
    this.startDate,
    this.endDate,
    this.discount,
    this.discountType,
    this.minimumShopping,
    this.maximumDiscount,
  });

  int id;
  String title;
  String couponCode;
  DateTime startDate;
  DateTime endDate;
  int discount;
  int discountType;
  int minimumShopping;
  int maximumDiscount;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        title: json["title"],
        couponCode: json["coupon_code"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        discount: json["discount"],
        discountType: json["discount_type"],
        minimumShopping: json["minimum_shopping"],
        maximumDiscount: json["maximum_discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "coupon_code": couponCode,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "discount": discount,
        "discount_type": discountType,
        "minimum_shopping": minimumShopping,
        "maximum_discount": maximumDiscount,
      };

  @override
  String toString() {
    return 'Coupon{id: $id, title: $title, couponCode: $couponCode, startDate: $startDate, endDate: $endDate, discount: $discount, discountType: $discountType, minimumShopping: $minimumShopping, maximumDiscount: $maximumDiscount}';
  }
}

class HomePageSlider {
  HomePageSlider({
    this.id,
    this.name,
    this.dataType,
    this.dataId,
    this.sliderImage,
    this.position,
    this.category,
    this.brand,
    this.tag,
  });

  int id;
  String name;
  SliderDataType dataType;
  dynamic dataId;
  String sliderImage;
  dynamic position;
  CategoryBrand category;
  CategoryBrand brand;
  CategoryBrand tag;

  factory HomePageSlider.fromJson(Map<String, dynamic> json) => HomePageSlider(
        id: json["id"],
        name: json["name"],
        dataType: nameValues.map[json["data_type"]],
        dataId: json["data_id"],
        sliderImage: json["slider_image"],
        position: json["position"],
        category: json["category"] == null
            ? null
            : CategoryBrand.fromJson(json["category"]),
        brand: json["brand"] == null
            ? null
            : CategoryBrand.fromJson(json["brand"]),
        tag: json["tag"] == null ? null : CategoryBrand.fromJson(json["tag"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "data_type": nameValues.reverse[dataType],
        "data_id": dataId,
        "slider_image": sliderImage,
        "position": position,
        "category": category == null ? null : category.toJson(),
        "brand": brand == null ? null : brand.toJson(),
        "tag": tag == null ? null : tag.toJson(),
      };

  @override
  String toString() {
    return 'HomePageSlider{id: $id, name: $name, dataType: $dataType, dataId: $dataId, sliderImage: $sliderImage, position: $position, category: $category, brand: $brand, tag: $tag}';
  }
}

enum SliderDataType { PRODUCT, CATEGORY, BRAND, TAG }

final nameValues = EnumValues({
  "product": SliderDataType.PRODUCT,
  "category": SliderDataType.CATEGORY,
  "brand": SliderDataType.BRAND,
  "tag": SliderDataType.TAG,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
