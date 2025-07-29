import 'dart:convert';

/// title : "English"
/// langText : "Hello!"
/// langCode : "en"
/// select_lang_text : "Select Language"
/// change_lang_text : "Change Language"
/// btn_continue : "Continue"
/// btn_update : "Update"

Language languageSelectionModelFromJson(String str) =>
    Language.fromJson(json.decode(str));

String languageSelectionModelToJson(Language data) =>
    json.encode(data.toJson());

List<Language> languageSelectionModelFromJsonList(List<dynamic> data) {
  return List<Language>.from(data.map((item) => Language.fromJson(item)));
}

class Language {
  Language({
    String? title,
    String? langText,
    String? langCode,
    String? selectLangText,
    String? changeLangText,
    String? btnContinue,
    String? btnUpdate,
  }) {
    _title = title;
    _langText = langText;
    _langCode = langCode;
    _selectLangText = selectLangText;
    _changeLangText = changeLangText;
    _btnContinue = btnContinue;
    _btnUpdate = btnUpdate;
  }

  Language.fromJson(dynamic json) {
    _title = json['title'];
    _langText = json['langText'];
    _langCode = json['langCode'];
    _selectLangText = json['select_lang_text'];
    _changeLangText = json['change_lang_text'];
    _btnContinue = json['btn_continue'];
    _btnUpdate = json['btn_update'];
  }

  String? _title;
  String? _langText;
  String? _langCode;
  String? _selectLangText;
  String? _changeLangText;
  String? _btnContinue;
  String? _btnUpdate;

  Language copyWith({
    String? title,
    String? langText,
    String? langCode,
    String? selectLangText,
    String? changeLangText,
    String? btnContinue,
    String? btnUpdate,
  }) =>
      Language(
        title: title ?? _title,
        langText: langText ?? _langText,
        langCode: langCode ?? _langCode,
        selectLangText: selectLangText ?? _selectLangText,
        changeLangText: changeLangText ?? _changeLangText,
        btnContinue: btnContinue ?? _btnContinue,
        btnUpdate: btnUpdate ?? _btnUpdate,
      );

  String get title => _title ?? "";

  String get langText => _langText ?? "";

  String get langCode => _langCode ?? "";

  String get selectLangText => _selectLangText ?? "";

  String get changeLangText => _changeLangText ?? "";

  String get btnContinue => _btnContinue ?? "";

  String get btnUpdate => _btnUpdate ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['langText'] = _langText;
    map['langCode'] = _langCode;
    map['select_lang_text'] = _selectLangText;
    map['change_lang_text'] = _changeLangText;
    map['btn_continue'] = _btnContinue;
    map['btn_update'] = _btnUpdate;
    return map;
  }
}
