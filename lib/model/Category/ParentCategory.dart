import 'package:amazy_app/model/Category/CategoryImage.dart';

class ParentCategory {
  ParentCategory({
    this.id,
    this.name,
    this.slug,
    this.parentId,
    this.depthLevel,
    this.icon,
    this.categoryImage,
    this.subCategories,
  });

  int id;
  String name;
  String slug;
  int parentId;
  int depthLevel;
  String icon;
  CategoryImage categoryImage;
  List<ParentCategory> subCategories;

  factory ParentCategory.fromJson(Map<String, dynamic> json) => ParentCategory(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        parentId: json["parent_id"],
        depthLevel: json["depth_level"],
        icon: json["icon"] == null ? null : json["icon"],
        categoryImage: json["category_image"] == null
            ? null
            : CategoryImage.fromJson(json["category_image"]),
        subCategories: json["sub_categories"] == null
            ? null
            : List<ParentCategory>.from(
                json["sub_categories"].map((x) => ParentCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "parent_id": parentId,
        "depth_level": depthLevel,
        "icon": icon == null ? null : icon,
        "category_image": categoryImage == null ? null : categoryImage.toJson(),
        "sub_categories": subCategories == null
            ? null
            : List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };
}
