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

  // TODO: wywalić
  static List<String> topCountries = [
    'England',
    'Spain',
    'Germany',
    'Italy',
    'France',
    'Poland',
    'World',
  ];

  @override
  int compareTo(Country other) {
    if (topCountries.contains(name)) {
      if (topCountries.contains(other.name)) {
        return name.compareTo(other.name);
      }
      return -1;
    }

    if (topCountries.contains(other.name)) return 1;

    return name.compareTo(other.name);
  }
}
