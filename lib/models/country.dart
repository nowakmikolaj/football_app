class Country implements Comparable<Country> {
  String name;
  String? code;
  String flag;

  Country(
    this.name,
    this.code,
    this.flag,
  );

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      json['name'],
      json['code'],
      json['flag'] ?? '',
    );
  }

  @override
  int compareTo(Country other) {
    return name.compareTo(other.name);
  }
}
