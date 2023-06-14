class Country {
  int id;
  String code;
  String name;
  String phonecode;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  Country({
    this.id,
    this.code,
    this.name,
    this.phonecode,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json["id"],
      code: json["code"],
      name: json["name"],
      phonecode: json["phonecode"],
      status: json["status"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "phonecode": phonecode,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class CountryList {
  List<Country> countries = [];

  CountryList({this.countries});

  factory CountryList.fromJson(List<dynamic> json) {
    List<Country> countryList;

    countryList = json.map((i) => Country.fromJson(i)).toList();

    return CountryList(countries: countryList);
  }
}
