import 'FilterAttributeValue.dart';

class FilterAttributeElement {
  FilterAttributeElement({
    this.id,
    this.name,
    this.displayType,
    this.description,
    this.status,
    this.values,
  });

  dynamic id;
  String name;
  String displayType;
  dynamic description;
  dynamic status;

  List<FilterAttributeValue> values;

  factory FilterAttributeElement.fromJson(Map<String, dynamic> json) =>
      FilterAttributeElement(
        id: json["id"],
        name: json["name"],
        displayType: json["display_type"],
        description: json["description"],
        status: json["status"],
        values: List<FilterAttributeValue>.from(
            json["values"].map((x) => FilterAttributeValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "display_type": displayType,
        "description": description,
        "status": status,
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
      };
}
