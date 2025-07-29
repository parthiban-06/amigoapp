// import 'dart:convert';
//
// import '../utils/secure_preferences.dart';
// import '../utils/utils.dart';
//
// Map<String, dynamic> data = {};
//
// class StorageData {
//   // late SharedPreferences prefs;
//
//   static const String email = "email";
//   static const String isSignUp = "isSignUp";
//   static const String forgotEmail = "forgot_email";
//
//   setPref() async {
//     getAllData();
//   }
//
//   getAllData() async {
//     var str = await Preferences.getString("myData") ?? "{}";
//     if (str != null) {
//       Utils.logPrint("in");
//       data = jsonDecode(str);
//     } else {
//       Utils.logPrint("out");
//     }
//   }
//
//   getData(String key) async {
//     print(data);
//     if (data.containsKey(key)) {
//       return data[key];
//     } else {
//       var str = await Preferences.getString("myData") ?? "{}";
//       Map<String, dynamic> data = jsonDecode(str);
//       if (data.containsKey(key)) {
//         return data[key];
//       } else {
//         return '';
//       }
//     }
//   }
//
//   setData(String key, dynamic value) async {
//     data[key] = value;
//     Preferences.setString("myData", jsonEncode(data));
//   }
// }
