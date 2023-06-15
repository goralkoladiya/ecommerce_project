import 'ProductVariations.dart';

class Skus {
  Skus({
    this.id,
    this.userId,
    this.productId,
    this.productSkuId,
    this.productStock,
    this.purchasePrice,
    this.sellingPrice,
    this.status,
    this.productVariations,
  });

  dynamic id;
  dynamic userId;
  dynamic productId;
  String productSkuId;
  String productStock;
  dynamic purchasePrice;
  String sellingPrice;
  dynamic status;
  List<ProductVariation> productVariations;

  factory Skus.fromJson(Map<String, dynamic> json) => Skus(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productSkuId: json["product_sku_id"],
        productStock: json["product_stock"],
        purchasePrice: json["purchase_price"],
        sellingPrice: json["selling_price"],
        status: json["status"],
        productVariations: List<ProductVariation>.from(
            json["product_variations"]
                .map((x) => ProductVariation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "product_sku_id": productSkuId,
        "product_stock": productStock,
        "purchase_price": purchasePrice,
        "selling_price": sellingPrice,
        "status": status,
        "product_variations":
            List<dynamic>.from(productVariations.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Skus{id: $id, userId: $userId, productId: $productId, productSkuId: $productSkuId, productStock: $productStock, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, status: $status, productVariations: $productVariations}';
  }
}
