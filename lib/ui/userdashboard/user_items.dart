import 'dart:convert';

UserItems userItemsFromJson(String str) => UserItems.fromJson(json.decode(str));

String userItemsToJson(UserItems data) => json.encode(data.toJson());

List<UserItems> genericUserItemsFromJsonList(List<dynamic> data) {
  return List<UserItems>.from(data.map((item) => UserItems.fromJson(item)));
}

class UserItems {
  UserItems({
    List<Users>? users,
    int? total,
    int? skip,
    int? limit,
  }) {
    _users = users;
    _total = total;
    _skip = skip;
    _limit = limit;
  }

  UserItems.fromJson(dynamic json) {
    if (json['users'] != null) {
      _users = [];
      json['users'].forEach((v) {
        _users?.add(Users.fromJson(v));
      });
    }
    _total = json['total'];
    _skip = json['skip'];
    _limit = json['limit'];
  }

  List<Users>? _users;
  int? _total;
  int? _skip;
  int? _limit;

  UserItems copyWith({
    List<Users>? users,
    int? total,
    int? skip,
    int? limit,
  }) =>
      UserItems(
        users: users ?? _users,
        total: total ?? _total,
        skip: skip ?? _skip,
        limit: limit ?? _limit,
      );

  List<Users>? get users => _users;

  int? get total => _total;

  int? get skip => _skip;

  int? get limit => _limit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_users != null) {
      map['users'] = _users?.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    map['skip'] = _skip;
    map['limit'] = _limit;
    return map;
  }
}

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    int? id,
    String? firstName,
    String? lastName,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
  }

  Users.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
  }

  int? _id;
  String? _firstName;
  String? _lastName;

  Users copyWith({
    int? id,
    String? firstName,
    String? lastName,
  }) =>
      Users(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
      );

  int? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    return map;
  }
}
