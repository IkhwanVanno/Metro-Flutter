class Group {
  final int id;
  final String title;
  final String code;

  Group({required this.id, required this.title, required this.code});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['ID'],
      title: json['Title'] ?? '',
      code: json['Code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'ID': id, 'Title': title, 'Code': code};
  }
}

class Member {
  final int id;
  final String firstName;
  final String surname;
  final String email;
  final String? tempIDHash;
  final DateTime? tempIDExpired;
  final List<Group> groups;

  Member({
    required this.id,
    required this.firstName,
    required this.surname,
    required this.email,
    this.tempIDHash,
    this.tempIDExpired,
    required this.groups,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      tempIDHash: json['temp_id_hash'],
      tempIDExpired: json['temp_id_expired'] != null
          ? DateTime.tryParse(json['temp_id_expired'])
          : null,
      groups: json['groups'] != null
          ? (json['groups'] as List).map((g) => Group.fromJson(g)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'surname': surname,
      'email': email,
      'temp_id_hash': tempIDHash,
      'temp_id_expired': tempIDExpired?.toIso8601String(),
      'groups': groups.map((g) => g.toJson()).toList(),
    };
  }

  String get fullName => '$firstName $surname';
}
