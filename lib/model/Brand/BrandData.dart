import 'package:amazy_app/model/Product/AllProducts.dart';

class BrandData {
  BrandData({
    this.id,
    this.name,
    this.logo,
    this.description,
    this.link,
    this.status,
    this.featured,
    this.metaTitle,
    this.metaDescription,
    this.sortId,
    this.totalSale,
    this.avgRating,
    this.slug,
    this.allProducts,
  });

  int id;
  String name;
  String logo;
  String description;
  dynamic link;
  dynamic status;
  dynamic featured;
  String metaTitle;
  String metaDescription;
  dynamic sortId;
  dynamic totalSale;
  dynamic avgRating;
  String slug;
  AllProducts allProducts;

  factory BrandData.fromJson(Map<String, dynamic> json) => BrandData(
        id: json["id"],
        name: json["name"],
        logo: json["logo"] == null ? null : json["logo"],
        description: json["description"] == null ? null : json["description"],
        link: json["link"],
        status: json["status"],
        featured: json["featured"],
        metaTitle: json["meta_title"] == null ? null : json["meta_title"],
        metaDescription:
            json["meta_description"] == null ? null : json["meta_description"],
        sortId: json["sort_id"],
        totalSale: json["total_sale"],
        avgRating: json["avg_rating"],
        slug: json["slug"],
        allProducts: json["AllProducts"] == null
            ? null
            : AllProducts.fromJson(json["AllProducts"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo == null ? null : logo,
        "description": description == null ? null : description,
        "link": link,
        "status": status,
        "featured": featured,
        "meta_title": metaTitle == null ? null : metaTitle,
        "meta_description": metaDescription == null ? null : metaDescription,
        "sort_id": sortId,
        "total_sale": totalSale,
        "avg_rating": avgRating,
        "slug": slug,
        "AllProducts": allProducts == null ? null : allProducts.toJson(),
      };

  @override
  String toString() {
    return 'BrandData{id: $id, name: $name, logo: $logo, description: $description, link: $link, status: $status, featured: $featured, metaTitle: $metaTitle, metaDescription: $metaDescription, sortId: $sortId, totalSale: $totalSale, avgRating: $avgRating, slug: $slug, allProducts: $allProducts}';
  }
}
