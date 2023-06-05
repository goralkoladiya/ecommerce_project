class FilterAttributeValue {
  FilterAttributeValue({
    this.id,
    this.value,
    this.attributeId,
  });

  dynamic id;
  String value;
  dynamic attributeId;

  factory FilterAttributeValue.fromJson(Map<String, dynamic> json) =>
      FilterAttributeValue(
        id: json["id"],
        value: json["value"],
        attributeId: json["attribute_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "attribute_id": attributeId,
      };
}
