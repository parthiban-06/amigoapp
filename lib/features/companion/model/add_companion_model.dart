class AddCompanion {
  final String firstName;
  final String lastName;
  final String email;
  final List<String> matchIds;

  AddCompanion({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.matchIds,
  });

  factory AddCompanion.fromJson(Map<String, dynamic> json) {
    return AddCompanion(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      matchIds: List<String>.from(json['match_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'match_ids': matchIds,
    };
  }

  Map<String, dynamic> toJsonEdit() {
    final map = <String, dynamic>{};

    map['first_name'] = firstName ?? "";
    map['last_name'] = lastName ?? "";

    if (matchIds.isNotEmpty) {
      map['match_ids'] = matchIds ?? [];
    }

    return map;

    // if (matchIds.isEmpty) {
    //   return {'first_name': firstName, 'last_name': lastName};
    // } else {
    //   return {
    //     'first_name': firstName,
    //     'last_name': lastName,
    //     'match_ids': matchIds
    //   };
    // }
  }
}
