import 'dart:convert';

Map<String, dynamic> _asStringKeyedMap(Object? value) {
  if (value is! Map) {
    return const <String, dynamic>{};
  }
  final result = <String, dynamic>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is String) {
      result[key] = entry.value;
    }
  }
  return result;
}

String _stringValue(Object? value) {
  return value is String ? value : '';
}

class SchoolSite {
  const SchoolSite({required this.name, required this.loginUrl});

  final String name;
  final String loginUrl;

  factory SchoolSite.fromJson(Map<String, dynamic> json) {
    return SchoolSite(
      name: _stringValue(json['name']),
      loginUrl: _stringValue(json['loginUrl']),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'loginUrl': loginUrl};

  SchoolSite copyWith({String? name, String? loginUrl}) {
    return SchoolSite(
      name: name ?? this.name,
      loginUrl: loginUrl ?? this.loginUrl,
    );
  }

  bool get isValid => name.trim().isNotEmpty && loginUrl.trim().isNotEmpty;
}

List<SchoolSite> decodeSchoolSites(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! List) {
    throw const FormatException('School site JSON format is invalid.');
  }
  final sites = decoded
      .map(_asStringKeyedMap)
      .where((item) => item.isNotEmpty)
      .map(SchoolSite.fromJson)
      .where((item) => item.isValid)
      .toList();
  if (decoded.isNotEmpty && sites.isEmpty) {
    throw const FormatException('School site JSON format is invalid.');
  }
  return sites;
}

String encodeSchoolSites(List<SchoolSite> sites) {
  return const JsonEncoder.withIndent(
    '  ',
  ).convert(sites.map((item) => item.toJson()).toList());
}
