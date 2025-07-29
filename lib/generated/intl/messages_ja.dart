// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static String m0(name) => "こんにちは、${name}様";

  static String m1(name) => "こんにちは、${name}様";

  static String m2(date) => "最終更新：${date}";

  static String m3(count) => "通知ボタン、${count}件の新しいメッセージ";

  static String m4(name) => "他に${name}ご質問はありますか？ ";

  static String m5(price) => "料金：${price}";

  static String m6(temp) => "温度：${temp}°C";

  static String m7(count) =>
      "${Intl.plural(count, one: 'チケット', other: 'チケット')}";

  static String m8(day, hour, sec) => "ワールドカップまであと${day}日${hour}時間${sec}秒です";

  static String m9(price) =>
      "${price}の数値から始まるトラベルクレジット。Booking.comで、このコードを貼り付けるよう求められます。";

  static String m10(email) => "認証コードが${email}へ送信されました";

  static String m11(name) => "ようこそ、${name}さん";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "a_newer_version_of_app": MessageLookupByLibrary.simpleMessage(
      "新しいバージョンのアプリが利用可能です。より良い体験のために今すぐアップデートしてください。",
    ),
    "absolutely_ecstatic": MessageLookupByLibrary.simpleMessage(
      "これ以上ないくらい大感激している",
    ),
    "access_my_personal_data": MessageLookupByLibrary.simpleMessage(
      "自分の個人データにアクセス",
    ),
    "access_wallet": MessageLookupByLibrary.simpleMessage("ウォレットにアクセスする"),
    "accommodation": MessageLookupByLibrary.simpleMessage("宿泊"),
    "account_not_verify": MessageLookupByLibrary.simpleMessage(
      "アカウントを認証する必要があります。Eメールを確認するか、コードを再送信してください。",
    ),
    "account_settings": MessageLookupByLibrary.simpleMessage("アカウント設定"),
    "activity": MessageLookupByLibrary.simpleMessage("アクティビティ"),
    "add": MessageLookupByLibrary.simpleMessage("追加"),
    "add_companion": MessageLookupByLibrary.simpleMessage("同伴者を追加"),
    "add_companion2": MessageLookupByLibrary.simpleMessage("同伴者の追加"),
    "add_itinerary_screen": MessageLookupByLibrary.simpleMessage("旅程の追加画面"),
    "add_itinerary_success": MessageLookupByLibrary.simpleMessage("旅程が追加されました"),
    "add_new_event": MessageLookupByLibrary.simpleMessage("新しいイベントを追加"),
    "add_to_apple_wallet": MessageLookupByLibrary.simpleMessage(
      "Apple Walletに追加する",
    ),
    "add_to_itinerary": MessageLookupByLibrary.simpleMessage("旅程に追加"),
    "add_travel_companion": MessageLookupByLibrary.simpleMessage("旅行の同伴者を追加"),
    "adding_a_companion_is_optional": MessageLookupByLibrary.simpleMessage(
      "同伴者の追加はオプションです。同伴者の方は、Visa Goアプリにのみアクセスできます。全てのチケットはFIFAアプリ経由で発行されます。FIFAワールドカップ 2026に同伴者を連れて行くために、Visa Goに同伴者を追加する必要はありません",
    ),
    "adding_a_companion_is_optional_semantic_label":
        MessageLookupByLibrary.simpleMessage(
          "同伴者の追加はオプションです。同伴者はVisa Goアプリのみ利用できます。すべてのチケットはFIFAアプリから発行されます。FIFAワールドカップ26に誰かを連れて行くためにVisa Goで同伴者を追加する必要はありません。",
        ),
    "adding_to_your_itinerary": MessageLookupByLibrary.simpleMessage(
      "旅程に追加しても、参加や予約の確定はされません。予約が必要な場合は、該当する施設に直接ご連絡ください。",
    ),
    "address": MessageLookupByLibrary.simpleMessage("住所"),
    "adults": MessageLookupByLibrary.simpleMessage("大人"),
    "adventure_experiences": MessageLookupByLibrary.simpleMessage(
      "アドベンチャーが味わえる場所",
    ),
    "afternoon": MessageLookupByLibrary.simpleMessage("午後"),
    "algeria": MessageLookupByLibrary.simpleMessage("アルジェリア"),
    "allow": MessageLookupByLibrary.simpleMessage("許可"),
    "allow_anonymous_analytics": MessageLookupByLibrary.simpleMessage(
      "匿名分析を許可して、体験を向上させるお手伝いをしてください。",
    ),
    "already_added": MessageLookupByLibrary.simpleMessage("追加済み"),
    "analyzing": MessageLookupByLibrary.simpleMessage("分析中..."),
    "and": MessageLookupByLibrary.simpleMessage(" かつ "),
    "any_booking_from_this": MessageLookupByLibrary.simpleMessage(
      "このセッションで行われた予約はすべて自動的にお客様の旅程プログラムに追加されます。",
    ),
    "anything_else": MessageLookupByLibrary.simpleMessage("他にご用はありますか？"),
    "api_timeout": MessageLookupByLibrary.simpleMessage("リクエストがタイムアウトしました。"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Visa-DHE"),
    "app_preferences_questions_attractions_interest":
        MessageLookupByLibrary.simpleMessage("どのような場所を探索したいですか？"),
    "app_preferences_questions_favoriteCuisine":
        MessageLookupByLibrary.simpleMessage("どのようなダイニング体験を求めていますか？"),
    "app_preferences_questions_hotel_features":
        MessageLookupByLibrary.simpleMessage("ホテルにはどのような特色を求めていますか？"),
    "app_preferences_questions_places_to_visit":
        MessageLookupByLibrary.simpleMessage("関心のあるアトラクションを選択してください。"),
    "app_settings": MessageLookupByLibrary.simpleMessage("アプリ設定"),
    "app_store_prompt": MessageLookupByLibrary.simpleMessage(
      "お客様のご体験に基づいて、他の人に伝えたいことはありますか？ アプリのストアでフィードバックを共有できます。",
    ),
    "app_version": MessageLookupByLibrary.simpleMessage("バージョン"),
    "are_you_sure": MessageLookupByLibrary.simpleMessage("操作を続行しますか？"),
    "argentina": MessageLookupByLibrary.simpleMessage("アルゼンチン"),
    "art": MessageLookupByLibrary.simpleMessage("アート"),
    "ask_eva": MessageLookupByLibrary.simpleMessage("EVAに尋ねる..."),
    "ask_eva_about_upcoming_match": MessageLookupByLibrary.simpleMessage(
      "近日中に観戦する試合について\nEVAに尋ねる",
    ),
    "ask_eva_travel": MessageLookupByLibrary.simpleMessage(
      "旅行の推奨事項について\nEVAに尋ねる",
    ),
    "ask_me_anything": MessageLookupByLibrary.simpleMessage("なんでもお尋ねください"),
    "at_least_8_characters": MessageLookupByLibrary.simpleMessage(
      "パスワードは8文字以上、20文字以内で指定してください",
    ),
    "attempt_left": MessageLookupByLibrary.simpleMessage("残りの試行"),
    "attempts_left": MessageLookupByLibrary.simpleMessage("残りの試行回数"),
    "attention_required": MessageLookupByLibrary.simpleMessage("注意が必要です"),
    "australia": MessageLookupByLibrary.simpleMessage("オーストラリア"),
    "authenticating": MessageLookupByLibrary.simpleMessage("認証中"),
    "authentication_failed": MessageLookupByLibrary.simpleMessage(
      "認証のオーケストレーションに失敗しました",
    ),
    "award_winning_food": MessageLookupByLibrary.simpleMessage(
      "\n受賞歴\nのあるレストラン",
    ),
    "back": MessageLookupByLibrary.simpleMessage("戻る"),
    "back_to_top": MessageLookupByLibrary.simpleMessage("トップに戻る"),
    "based_on_your_experience": MessageLookupByLibrary.simpleMessage(
      "お客様のご体験に基づいて、他の人に伝えたいことはありますか？ アプリのストアでフィードバックを共有できます。",
    ),
    "before_you_delete": MessageLookupByLibrary.simpleMessage(
      "削除する前に、以下のオプションを検討してください。",
    ),
    "belgium": MessageLookupByLibrary.simpleMessage("ベルギー"),
    "bioAuth": MessageLookupByLibrary.simpleMessage("生体認証"),
    "bioAuthFail": MessageLookupByLibrary.simpleMessage(
      "生体認証に失敗しました。再試行してください。",
    ),
    "bioAuthSuccess": MessageLookupByLibrary.simpleMessage("生体認証が有効化されました"),
    "biometric_disable_error": MessageLookupByLibrary.simpleMessage(
      "生体認証の無効化に失敗しました。再試行してください。",
    ),
    "biometric_disable_success": MessageLookupByLibrary.simpleMessage(
      "生体認証がオフになりました。",
    ),
    "biometric_enable_error": MessageLookupByLibrary.simpleMessage(
      "生体認証の有効化に失敗しました。再試行してください。",
    ),
    "biometric_enable_success": MessageLookupByLibrary.simpleMessage(
      "生体認証が正常に有効化されました。",
    ),
    "biometric_not_supported": MessageLookupByLibrary.simpleMessage(
      "このデバイスは生体認証に対応していません。",
    ),
    "biometrics": MessageLookupByLibrary.simpleMessage("生体認証"),
    "body": MessageLookupByLibrary.simpleMessage("本文"),
    "book_and_more": MessageLookupByLibrary.simpleMessage(
      "フライト、ホテル、\n交通手段などをご予約ください",
    ),
    "book_travel": MessageLookupByLibrary.simpleMessage("ご旅行の\n予約"),
    "book_travel2": MessageLookupByLibrary.simpleMessage("ご旅行の予約"),
    "booking_com": MessageLookupByLibrary.simpleMessage("Booking.com"),
    "booking_support": MessageLookupByLibrary.simpleMessage("Booking.comのサポート"),
    "booking_terms_conditions": MessageLookupByLibrary.simpleMessage(
      "Booking.comの利用規約",
    ),
    "boutique": MessageLookupByLibrary.simpleMessage("ブティック"),
    "brazil": MessageLookupByLibrary.simpleMessage("ブラジル"),
    "brunch": MessageLookupByLibrary.simpleMessage("ブランチ"),
    "button": MessageLookupByLibrary.simpleMessage("ボタン"),
    "by_creating_an_account": MessageLookupByLibrary.simpleMessage(
      "アカウントを作成することにより、利用規約およびプライバシー通知を読み、これらに同意したものと見なされます。",
    ),
    "cafe": MessageLookupByLibrary.simpleMessage("カフェ"),
    "cafes": MessageLookupByLibrary.simpleMessage("カフェ"),
    "calendar": MessageLookupByLibrary.simpleMessage("カレンダー"),
    "calendar_header": MessageLookupByLibrary.simpleMessage("カレンダー見出し"),
    "cameroon": MessageLookupByLibrary.simpleMessage("カメルーン"),
    "can_i_still_go": MessageLookupByLibrary.simpleMessage(
      "FIFAワールドカップ 2026にまだ行けますか？",
    ),
    "canada": MessageLookupByLibrary.simpleMessage("カナダ"),
    "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "cancel_editing_message": MessageLookupByLibrary.simpleMessage(
      "メッセージの編集をキャンセル",
    ),
    "card": MessageLookupByLibrary.simpleMessage("カード"),
    "card_access_begins": MessageLookupByLibrary.simpleMessage("カードへのアクセス開始日"),
    "casual_restaurants": MessageLookupByLibrary.simpleMessage("カジュアルなレストラン"),
    "category_is_required": MessageLookupByLibrary.simpleMessage("カテゴリーは必須です"),
    "category_optional": MessageLookupByLibrary.simpleMessage("カテゴリー*"),
    "category_required": MessageLookupByLibrary.simpleMessage("必須のカテゴリー"),
    "celsius": MessageLookupByLibrary.simpleMessage("°C"),
    "change_calendar_format": MessageLookupByLibrary.simpleMessage(
      "カレンダーの書式を変更する",
    ),
    "change_email_id": MessageLookupByLibrary.simpleMessage("ユーザーの切り替え"),
    "change_language": MessageLookupByLibrary.simpleMessage("言語の変更"),
    "change_password": MessageLookupByLibrary.simpleMessage("パスワードの変更"),
    "change_password_screen": MessageLookupByLibrary.simpleMessage(
      "パスワードの変更画面",
    ),
    "changed_to_dislike": MessageLookupByLibrary.simpleMessage("「低評価」に変更しました"),
    "changed_to_like": MessageLookupByLibrary.simpleMessage("「いいね！」に変更しました"),
    "chat_history_updated": MessageLookupByLibrary.simpleMessage(
      "チャット履歴が更新されました",
    ),
    "check_balance": MessageLookupByLibrary.simpleMessage("残高を確認"),
    "check_box": MessageLookupByLibrary.simpleMessage("チェックボックス"),
    "check_connection": MessageLookupByLibrary.simpleMessage("接続を確認してください。"),
    "check_current_balance": MessageLookupByLibrary.simpleMessage(
      "Booking.comで\n現在の残高を確認する",
    ),
    "check_fifa": MessageLookupByLibrary.simpleMessage("FIFAで"),
    "check_fifa_faqs": MessageLookupByLibrary.simpleMessage("FIFAのよくある質問を確認して"),
    "check_fifa_tail": MessageLookupByLibrary.simpleMessage("最新情報を確認してください。"),
    "checkbox": MessageLookupByLibrary.simpleMessage("チェックボックス"),
    "checked": MessageLookupByLibrary.simpleMessage("チェック済み"),
    "chile": MessageLookupByLibrary.simpleMessage("チリ"),
    "choose_language": MessageLookupByLibrary.simpleMessage("言語を選択してください"),
    "city": MessageLookupByLibrary.simpleMessage("都市"),
    "click_or_drag_make_selection": MessageLookupByLibrary.simpleMessage(
      "クリックまたはドラッグして選択してください。",
    ),
    "client_error": MessageLookupByLibrary.simpleMessage("Eメールアドレスが無効です"),
    "close": MessageLookupByLibrary.simpleMessage("閉じる"),
    "close_tutorial": MessageLookupByLibrary.simpleMessage("チュートリアルを閉じる"),
    "closed": MessageLookupByLibrary.simpleMessage("終了"),
    "cnf_pass": MessageLookupByLibrary.simpleMessage("新しいパスワードを確認"),
    "code_copied": MessageLookupByLibrary.simpleMessage("コードがコピーされました"),
    "code_send": MessageLookupByLibrary.simpleMessage("コードが送信されました"),
    "collapse": MessageLookupByLibrary.simpleMessage("一部を表示"),
    "collapse_details": MessageLookupByLibrary.simpleMessage("チケットの詳細を折りたたむ"),
    "collapsed": MessageLookupByLibrary.simpleMessage("一部を表示"),
    "colombia": MessageLookupByLibrary.simpleMessage("コロンビア"),
    "come_back_message": MessageLookupByLibrary.simpleMessage(
      "万が一アプリを再度利用する場合は、新しいアカウントを作成する必要があります。",
    ),
    "companion": MessageLookupByLibrary.simpleMessage("同伴者"),
    "companion_added": MessageLookupByLibrary.simpleMessage("同伴者が追加されました"),
    "companion_capacity_full": MessageLookupByLibrary.simpleMessage(
      "上限に達しました。このマッチにはユーザーを再割り当てすることしかできません。",
    ),
    "companion_deleted": MessageLookupByLibrary.simpleMessage("同伴者が削除されました"),
    "companion_details": MessageLookupByLibrary.simpleMessage("同伴者の詳細情報"),
    "companion_details_screen": MessageLookupByLibrary.simpleMessage(
      "同伴者の詳細画面",
    ),
    "companion_edit_completed": MessageLookupByLibrary.simpleMessage(
      "同伴者が編集されました",
    ),
    "companion_email": MessageLookupByLibrary.simpleMessage("同伴者のEメールアドレス"),
    "companion_email_cannot_be_edited": MessageLookupByLibrary.simpleMessage(
      "同伴者のEメールアドレスは編集できません。同伴者のEメールアドレスを変更する必要がある場合は、まずこの同伴者を削除してから新規の同伴者として追加してください。",
    ),
    "companion_invite_has_been_resent": MessageLookupByLibrary.simpleMessage(
      "同伴者への招待が再送信されました。",
    ),
    "companion_registration": MessageLookupByLibrary.simpleMessage("同伴者の登録"),
    "companion_screen": MessageLookupByLibrary.simpleMessage("同伴者の画面"),
    "completely_thrilled": MessageLookupByLibrary.simpleMessage("大興奮でワクワクしている"),
    "confirm": MessageLookupByLibrary.simpleMessage("確認"),
    "confirm_account_deletion": MessageLookupByLibrary.simpleMessage(
      "アカウントの削除を確定する",
    ),
    "confirm_code_screen": MessageLookupByLibrary.simpleMessage("コードの確認画面"),
    "confirm_forgot_password_screen": MessageLookupByLibrary.simpleMessage(
      "パスワードを忘れた場合の確認画面",
    ),
    "confirm_password": MessageLookupByLibrary.simpleMessage("パスワードを確認"),
    "confirm_password_is_required": MessageLookupByLibrary.simpleMessage(
      "確認パスワードを入力してください",
    ),
    "confirmation": MessageLookupByLibrary.simpleMessage("確認"),
    "congrats_your_heard": MessageLookupByLibrary.simpleMessage(
      "おめでとうございます。FIFAWorld Cup™の観戦が決定しました。",
    ),
    "connection_refused": MessageLookupByLibrary.simpleMessage("データを取得できません。"),
    "contact_support": MessageLookupByLibrary.simpleMessage("サポートに連絡する"),
    "contact_visa_go_com": MessageLookupByLibrary.simpleMessage(
      "contact@visago.com",
    ),
    "contact_visa_support": MessageLookupByLibrary.simpleMessage("サポートに連絡する"),
    "conversation_delete": MessageLookupByLibrary.simpleMessage(
      "会話は正常に削除されました。",
    ),
    "conversation_delete_error": MessageLookupByLibrary.simpleMessage(
      "削除する会話を選択してください",
    ),
    "conversation_history": MessageLookupByLibrary.simpleMessage("コンバージョン履歴"),
    "copied": MessageLookupByLibrary.simpleMessage("コピー済み"),
    "copy": MessageLookupByLibrary.simpleMessage("コピー"),
    "copy_code": MessageLookupByLibrary.simpleMessage("コードをコピー"),
    "copy_url": MessageLookupByLibrary.simpleMessage("URLをコピー"),
    "costa_rica": MessageLookupByLibrary.simpleMessage("コスタリカ"),
    "could_not_launch": MessageLookupByLibrary.simpleMessage("起動できませんでした"),
    "countdown_to_fifa_word_cup": MessageLookupByLibrary.simpleMessage(
      "FIFAワールドカップまでのカウントダウン：",
    ),
    "create_acc_signup": MessageLookupByLibrary.simpleMessage(
      "アカウントを作成 サインアップ",
    ),
    "create_password": MessageLookupByLibrary.simpleMessage("パスワードを作成"),
    "croatia": MessageLookupByLibrary.simpleMessage("クロアチア"),
    "current_password": MessageLookupByLibrary.simpleMessage("現在のパスワード"),
    "current_password_is_required": MessageLookupByLibrary.simpleMessage(
      "現在のパスワードを入力してください",
    ),
    "date": MessageLookupByLibrary.simpleMessage("日付"),
    "date_field": MessageLookupByLibrary.simpleMessage("日付フィールド"),
    "date_format": MessageLookupByLibrary.simpleMessage("DD/MM/YYYY"),
    "date_is_invalid": MessageLookupByLibrary.simpleMessage("日付が無効です"),
    "date_is_required": MessageLookupByLibrary.simpleMessage("日付は必須です"),
    "days": MessageLookupByLibrary.simpleMessage("日"),
    "decline": MessageLookupByLibrary.simpleMessage("拒否"),
    "delete": MessageLookupByLibrary.simpleMessage("削除"),
    "delete_account": MessageLookupByLibrary.simpleMessage("アカウントを削除"),
    "delete_companion_dialog": MessageLookupByLibrary.simpleMessage(
      "同伴者ダイアログを削除",
    ),
    "delete_event_can_not_undone": MessageLookupByLibrary.simpleMessage(
      "イベントを削除すると、取り消しはできません。",
    ),
    "delete_my_account": MessageLookupByLibrary.simpleMessage("アカウントを削除"),
    "delete_your_account": MessageLookupByLibrary.simpleMessage(
      "アカウントを削除しますか？",
    ),
    "delete_your_companion": MessageLookupByLibrary.simpleMessage(
      "同伴者を削除しますか？",
    ),
    "deleting_your_account": MessageLookupByLibrary.simpleMessage(
      "アカウントを削除すると、保存したすべてのデータも失われます。",
    ),
    "denmark": MessageLookupByLibrary.simpleMessage("デンマーク"),
    "description": MessageLookupByLibrary.simpleMessage("説明"),
    "description_optional": MessageLookupByLibrary.simpleMessage("説明（オプション）"),
    "detail_card": MessageLookupByLibrary.simpleMessage("詳細カード"),
    "developer_mode_description": MessageLookupByLibrary.simpleMessage(
      "申し訳ございません。セキュリティのため、このアプリは開発者モードがオンの状態で動作することはできません。お使いの電話の設定で開発者モードをオフにしてから、もう一度お試しください。",
    ),
    "dialog": MessageLookupByLibrary.simpleMessage("ダイアログ"),
    "did_not_receive_a_code": MessageLookupByLibrary.simpleMessage(
      "コードを受信していませんか？",
    ),
    "dining_experience": MessageLookupByLibrary.simpleMessage("お気に入りのダイニング体験"),
    "direct_flights": MessageLookupByLibrary.simpleMessage("直行便\n"),
    "disable": MessageLookupByLibrary.simpleMessage("無効化"),
    "disable_24hrs_clock": MessageLookupByLibrary.simpleMessage(
      "24時間形式の時間が無効化されました。",
    ),
    "disable_push_notification": MessageLookupByLibrary.simpleMessage(
      "プッシュ通知を無効にする",
    ),
    "disable_to_hide_password": MessageLookupByLibrary.simpleMessage(
      "無効化してパスワードを非表示にします",
    ),
    "disabled_button_text_field_label": MessageLookupByLibrary.simpleMessage(
      "すべての必須項目を入力してください",
    ),
    "disliked_the_message": MessageLookupByLibrary.simpleMessage(
      "メッセージに「低評価」を付けました",
    ),
    "done": MessageLookupByLibrary.simpleMessage("完了"),
    "dont_show_me_this": MessageLookupByLibrary.simpleMessage(
      "次回からリマインダーを表示しない",
    ),
    "double_tap_to_activate": MessageLookupByLibrary.simpleMessage(
      "ボタン、ダブルタップして有効化",
    ),
    "double_tap_to_activate_link": MessageLookupByLibrary.simpleMessage(
      "リンク、ダブルタップで有効化",
    ),
    "double_tap_to_collapse": MessageLookupByLibrary.simpleMessage(
      "ボタン。ダブルタップして折りたたむ",
    ),
    "double_tap_to_collapse_expand": MessageLookupByLibrary.simpleMessage(
      "ダブルタップすると、セクションのすべてあるいは一部を表示できます。",
    ),
    "double_tap_to_edit": MessageLookupByLibrary.simpleMessage(
      "ダブルタップして編集します。",
    ),
    "double_tap_to_expand": MessageLookupByLibrary.simpleMessage(
      "ボタン。ダブルタップして展開し、さらに日付を表示",
    ),
    "double_tap_to_select": MessageLookupByLibrary.simpleMessage(
      "ダブルタップして選択します。",
    ),
    "double_tap_to_select_location": MessageLookupByLibrary.simpleMessage(
      "ダブルタップしてロケーションを選択します",
    ),
    "double_tap_to_unselect": MessageLookupByLibrary.simpleMessage(
      "ダブルタップして選択を解除します。",
    ),
    "downtown": MessageLookupByLibrary.simpleMessage("ダウンタウンにある"),
    "dr_congo": MessageLookupByLibrary.simpleMessage("コンゴ民主共和国"),
    "ecuador": MessageLookupByLibrary.simpleMessage("エクアドル"),
    "edit_box": MessageLookupByLibrary.simpleMessage("編集ボックス"),
    "edit_companion": MessageLookupByLibrary.simpleMessage("同伴者の編集"),
    "edit_event": MessageLookupByLibrary.simpleMessage("イベントの編集"),
    "edit_event_details_button": MessageLookupByLibrary.simpleMessage(
      "イベント詳細を編集、ボタン",
    ),
    "edit_itinerary_success": MessageLookupByLibrary.simpleMessage(
      "旅程が更新されました",
    ),
    "edit_language_screen": MessageLookupByLibrary.simpleMessage("言語画面の編集"),
    "edit_message_icon": MessageLookupByLibrary.simpleMessage("メッセージの編集アイコン"),
    "edit_profile": MessageLookupByLibrary.simpleMessage("プロフィールを編集"),
    "edit_profile_details": MessageLookupByLibrary.simpleMessage("プロフィール情報を編集"),
    "editorial_summary": MessageLookupByLibrary.simpleMessage("編集の概要"),
    "egypt": MessageLookupByLibrary.simpleMessage("エジプト"),
    "email": MessageLookupByLibrary.simpleMessage("Eメール"),
    "email_is_required": MessageLookupByLibrary.simpleMessage("Eメールを入力してください"),
    "email_verification": MessageLookupByLibrary.simpleMessage("Eメールの確認"),
    "empty_team_text": MessageLookupByLibrary.simpleMessage(
      "文字が入力されていません。チームを探すには文字を入力するか選択してください。",
    ),
    "enable": MessageLookupByLibrary.simpleMessage("有効化"),
    "enable_auth": MessageLookupByLibrary.simpleMessage("2要素認証を有効にする"),
    "enable_bio": MessageLookupByLibrary.simpleMessage("生体認証を有効化"),
    "enable_biometric": MessageLookupByLibrary.simpleMessage("生体認証を有効化しますか？"),
    "enable_face_id": MessageLookupByLibrary.simpleMessage("顔認証システムを有効化しますか？"),
    "enable_push_notiifcation": MessageLookupByLibrary.simpleMessage(
      "更新を受け取るには、設定からの通知を有効にしてください。",
    ),
    "enable_to_view_password": MessageLookupByLibrary.simpleMessage(
      "有効化してパスワードを表示します",
    ),
    "end_optional": MessageLookupByLibrary.simpleMessage("終了日（オプション）"),
    "end_time_field": MessageLookupByLibrary.simpleMessage("終了時間"),
    "end_time_is_invalid": MessageLookupByLibrary.simpleMessage("終了時間が無効です"),
    "end_time_is_required": MessageLookupByLibrary.simpleMessage("終了時間は必須です"),
    "england": MessageLookupByLibrary.simpleMessage("イングランド"),
    "ent_code": MessageLookupByLibrary.simpleMessage("コードを入力"),
    "enter_code_below": MessageLookupByLibrary.simpleMessage("以下にコードを入力してください"),
    "enter_password_to_confirm": MessageLookupByLibrary.simpleMessage(
      "確認のためパスワードを入力してください",
    ),
    "enter_time_using": MessageLookupByLibrary.simpleMessage(
      "時間は、目的地の現地時間で入力してください。",
    ),
    "enter_your_password": MessageLookupByLibrary.simpleMessage(
      "パスワードを入力してください",
    ),
    "enter_your_verification_code": MessageLookupByLibrary.simpleMessage(
      "認証コードを入力してください",
    ),
    "error": MessageLookupByLibrary.simpleMessage("エラー"),
    "eva": MessageLookupByLibrary.simpleMessage("EVA"),
    "eva_ai_powered_concierge": MessageLookupByLibrary.simpleMessage(
      "Explore Voyage Access (EVA)\nAIによるコンシェルジュ",
    ),
    "eva_ai_powered_concierge_info": MessageLookupByLibrary.simpleMessage(
      "それが私です！ご旅行についてどんなことでもお尋ねください。レストランから穴場スポット、ホテルの情報まで、思い出に残るご旅行になるようお手伝いをさせていただきます。",
    ),
    "eva_chat_history_screen": MessageLookupByLibrary.simpleMessage("会話歴の画面"),
    "eva_chat_screen_opened": MessageLookupByLibrary.simpleMessage(
      "EVAチャット画面が開いています。ここで質問をするか、推奨事項を受け取ることができます。画面下部にメッセージを入力してください。",
    ),
    "eva_copy": MessageLookupByLibrary.simpleMessage("EVAの応答がコピーされました。"),
    "eva_history": MessageLookupByLibrary.simpleMessage("EVAコンバージョン履歴"),
    "eva_history_tab": MessageLookupByLibrary.simpleMessage("EVA会話履歴タブ"),
    "eva_tab": MessageLookupByLibrary.simpleMessage("EVAタブ"),
    "eva_tutorial": MessageLookupByLibrary.simpleMessage("EVAのチュートリアル"),
    "evening": MessageLookupByLibrary.simpleMessage("夕方"),
    "event_added": MessageLookupByLibrary.simpleMessage("イベントが追加されました"),
    "event_information": MessageLookupByLibrary.simpleMessage("イベント情報"),
    "event_name": MessageLookupByLibrary.simpleMessage("イベント名"),
    "event_name_is_invalid": MessageLookupByLibrary.simpleMessage("イベント名が無効です"),
    "event_name_is_required": MessageLookupByLibrary.simpleMessage(
      "イベント名は必須フィールドです",
    ),
    "events_local_time_zone": MessageLookupByLibrary.simpleMessage(
      "イベントは現地時間で表示されています。",
    ),
    "everywhere_you_want": MessageLookupByLibrary.simpleMessage("あなたの目指すところへ"),
    "exceptional_eats": MessageLookupByLibrary.simpleMessage("とっておきのメニュー"),
    "exceptional_menus": MessageLookupByLibrary.simpleMessage("とっておきのメニュー"),
    "excited": MessageLookupByLibrary.simpleMessage("大興奮しています！"),
    "expand": MessageLookupByLibrary.simpleMessage("すべて表示"),
    "expand_details": MessageLookupByLibrary.simpleMessage("チケットの詳細を展開"),
    "expanded": MessageLookupByLibrary.simpleMessage("すべて表示"),
    "explore_activity_eva": MessageLookupByLibrary.simpleMessage(
      "EVAで近隣のアクティビティを\n探索する",
    ),
    "explore_off": MessageLookupByLibrary.simpleMessage("穴場を探す"),
    "faceIdAvailable": MessageLookupByLibrary.simpleMessage(
      "顔認証システムが利用できるようになりました。顔認証IDを有効化することで、必要な情報にすばやくアクセスできます",
    ),
    "face_id": MessageLookupByLibrary.simpleMessage("Face ID"),
    "fahrenheit": MessageLookupByLibrary.simpleMessage("°F"),
    "failed_response": MessageLookupByLibrary.simpleMessage(
      "応答の取得に失敗しました。再試行してください。",
    ),
    "failed_to_delete_account": MessageLookupByLibrary.simpleMessage(
      "アカウントの削除に失敗しました",
    ),
    "family_friendly_fun": MessageLookupByLibrary.simpleMessage("家族で楽しめる場所"),
    "faq": MessageLookupByLibrary.simpleMessage("よくある質問"),
    "faq_page": MessageLookupByLibrary.simpleMessage("FAQページ"),
    "faq_screen": MessageLookupByLibrary.simpleMessage("よくある質問画面"),
    "faq_tab": MessageLookupByLibrary.simpleMessage("よくある質問タブ"),
    "faqs": MessageLookupByLibrary.simpleMessage("よくあるご質問"),
    "fetching_data": MessageLookupByLibrary.simpleMessage("データを取得しています..."),
    "fifa_ticket_support": MessageLookupByLibrary.simpleMessage(
      "FIFAのチケットサポート",
    ),
    "fifa_word_cup_26": MessageLookupByLibrary.simpleMessage(
      "FIFAワールドカップ 2026",
    ),
    "fifa_word_cup_semantic_label": MessageLookupByLibrary.simpleMessage(
      "FIFAワールドカップ26",
    ),
    "find_hotels": MessageLookupByLibrary.simpleMessage("希望のアメニティを備えたホテルを探す"),
    "fine_dining": MessageLookupByLibrary.simpleMessage("洗練されたレストラン"),
    "first_june_2026": MessageLookupByLibrary.simpleMessage("2026年6月1日"),
    "first_name": MessageLookupByLibrary.simpleMessage("名"),
    "first_name_is_required": MessageLookupByLibrary.simpleMessage(
      "名は必須フィールドです",
    ),
    "first_time_pref": MessageLookupByLibrary.simpleMessage("言語を選択してください。"),
    "fitness_center": MessageLookupByLibrary.simpleMessage("フィットネスセンターがある"),
    "food_and_drink": MessageLookupByLibrary.simpleMessage("フード＆ドリンク"),
    "food_tours": MessageLookupByLibrary.simpleMessage("グルメツアー"),
    "for_questions": MessageLookupByLibrary.simpleMessage(
      "ご質問がある場合は以下を参照してください：",
    ),
    "for_text": MessageLookupByLibrary.simpleMessage("期間"),
    "forgot_password": MessageLookupByLibrary.simpleMessage("パスワードをお忘れの場合"),
    "forgot_password_please_ent": MessageLookupByLibrary.simpleMessage(
      "パスワードをお忘れの場合 Eメールアドレスを入力して続行してください。",
    ),
    "forgot_password_screen": MessageLookupByLibrary.simpleMessage(
      "パスワードを忘れた場合の画面",
    ),
    "four_of_four": MessageLookupByLibrary.simpleMessage("4 分の 4"),
    "france": MessageLookupByLibrary.simpleMessage("フランス"),
    "frequently_asked_questions": MessageLookupByLibrary.simpleMessage(
      "よくある質問",
    ),
    "ftt_match_ticket": MessageLookupByLibrary.simpleMessage("試合のチケット/詳細情報"),
    "ftt_match_ticket_desc": MessageLookupByLibrary.simpleMessage(
      "Lorem ipsum dolor sit amet consectetur. Amet tellus justo dignissim urna.",
    ),
    "ftt_title": MessageLookupByLibrary.simpleMessage("試合のタイトル"),
    "gathering_info": MessageLookupByLibrary.simpleMessage("情報を収集中..."),
    "germany": MessageLookupByLibrary.simpleMessage("ドイツ"),
    "get_faster_access": MessageLookupByLibrary.simpleMessage(
      "必要な情報に、よりスピーディにアクセスしましょう。このオプションはプロフィールでいつでも有効化・無効化できます。",
    ),
    "get_ready_to_explore": MessageLookupByLibrary.simpleMessage(
      "さあ、探検を始めましょう",
    ),
    "getting_to_konw_screen": MessageLookupByLibrary.simpleMessage(
      "知っておくべきことの画面",
    ),
    "ghana": MessageLookupByLibrary.simpleMessage("ガーナ"),
    "give_permission_label": MessageLookupByLibrary.simpleMessage("許可します"),
    "goal": MessageLookupByLibrary.simpleMessage("ゴール！"),
    "goal_of_the_trip": MessageLookupByLibrary.simpleMessage("お客さまの旅の目的は何ですか？"),
    "goal_of_trip": MessageLookupByLibrary.simpleMessage("ご旅行で「決めたいゴール」は何ですか？"),
    "good_afternoon": MessageLookupByLibrary.simpleMessage("こんにちは"),
    "good_evening": MessageLookupByLibrary.simpleMessage("こんばんは"),
    "good_morning": MessageLookupByLibrary.simpleMessage("おはようございます"),
    "got_it": MessageLookupByLibrary.simpleMessage("分かりました"),
    "greeting_screen_content": MessageLookupByLibrary.simpleMessage(
      "旅行の計画、推奨事項、その他。AIによるコンシェルジュ、EVAがお手伝いします。",
    ),
    "group_match_day": MessageLookupByLibrary.simpleMessage("試合日"),
    "guide_for_email": MessageLookupByLibrary.simpleMessage(
      "Visa Go招待メールに関連づけられているEメールアドレスを入力してください。",
    ),
    "have_acc": MessageLookupByLibrary.simpleMessage("アカウントをすでにお持ちですか？ サインイン"),
    "have_you_redeemed": MessageLookupByLibrary.simpleMessage(
      "トラベルクレジットの交換はお済みですか？",
    ),
    "header_long_pressed": MessageLookupByLibrary.simpleMessage("ヘッダーの長押し"),
    "hello": MessageLookupByLibrary.simpleMessage("こんにちは"),
    "helloMessage": m0,
    "help": MessageLookupByLibrary.simpleMessage("ヘルプ"),
    "help_protect_ur_acc": MessageLookupByLibrary.simpleMessage(
      "パスワードに加えて、2つ目の認証方法を義務付けることでアカウントを不正なアクセスから保護できます。",
    ),
    "help_protect_your_acc": MessageLookupByLibrary.simpleMessage(
      "パスワードに加えて2つ目の認証方法を義務付けることで、アカウントを不正なアクセスから保護できます。",
    ),
    "help_us_improve": MessageLookupByLibrary.simpleMessage("改善にご協力ください"),
    "hi": MessageLookupByLibrary.simpleMessage("こんにちは、"),
    "hiMessage": m1,
    "hidden_gems": MessageLookupByLibrary.simpleMessage("穴場の\nスポット"),
    "high": MessageLookupByLibrary.simpleMessage("H："),
    "high_text": MessageLookupByLibrary.simpleMessage("高"),
    "highlights_you": MessageLookupByLibrary.simpleMessage("見逃せないハイライト"),
    "hiking": MessageLookupByLibrary.simpleMessage("ハイキング"),
    "historic_landmarks": MessageLookupByLibrary.simpleMessage("歴史的な観光名所"),
    "historical_landmarks": MessageLookupByLibrary.simpleMessage("歴史的な観光名所"),
    "history": MessageLookupByLibrary.simpleMessage("歴史"),
    "home": MessageLookupByLibrary.simpleMessage("ホーム"),
    "home_screen": MessageLookupByLibrary.simpleMessage("ホーム画面"),
    "home_tab": MessageLookupByLibrary.simpleMessage("ホームタブ"),
    "home_tutorial": MessageLookupByLibrary.simpleMessage("ホームチュートリアル"),
    "hotel_name": MessageLookupByLibrary.simpleMessage("ホテル名"),
    "hotel_with_restaurant": MessageLookupByLibrary.simpleMessage(
      "レストランのある\nホテル",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("時間"),
    "how_are_doing": MessageLookupByLibrary.simpleMessage("ご感想をお聞かせください。"),
    "how_excited": MessageLookupByLibrary.simpleMessage(
      "FIFAワールドカップ 2026をどのくらい楽しみにしていますか？",
    ),
    "how_to_use": MessageLookupByLibrary.simpleMessage("使用方法"),
    "hr_clock": MessageLookupByLibrary.simpleMessage("24時間表示"),
    "hrs": MessageLookupByLibrary.simpleMessage("時間"),
    "iAcknowledge_and_iAgree_error": MessageLookupByLibrary.simpleMessage(
      "続行する前に、すべての必要な利用規約に同意してください。",
    ),
    "iAcknowledge_not_selected": MessageLookupByLibrary.simpleMessage(
      "登録を続行するには、利用規約に同意する必要があります。",
    ),
    "iAgree_not_selected": MessageLookupByLibrary.simpleMessage(
      "登録を続行するには、同伴者の利用規約に同意する必要があります。",
    ),
    "i_acknowledge": MessageLookupByLibrary.simpleMessage("同意します"),
    "i_acknowledge_label": MessageLookupByLibrary.simpleMessage("同意します"),
    "i_acknowledge_that": MessageLookupByLibrary.simpleMessage(
      "同伴者を追加することで、Visa Goへのアクセスのみが提供されることを理解し、また、全てのチケットはFIFAアプリ*経由で発行されることに同意します。",
    ),
    "i_acknowledge_that_i": MessageLookupByLibrary.simpleMessage(
      "以下を読み、理解したことに同意します ",
    ),
    "i_cant_wait": MessageLookupByLibrary.simpleMessage("待ち切れない"),
    "i_confirm_that": MessageLookupByLibrary.simpleMessage("以下を読み、同意します "),
    "i_know_more_about": MessageLookupByLibrary.simpleMessage(
      "さあ、忘れられない思い出を作りましょう。旅の準備を開始しましょう。",
    ),
    "i_m_here_to_help": MessageLookupByLibrary.simpleMessage(
      "私はEVAです。お客様が試合観戦において必要なあらゆる情報の検索、体験、アクセスをお手伝いします。",
    ),
    "icon": MessageLookupByLibrary.simpleMessage("アイコン"),
    "image_of": MessageLookupByLibrary.simpleMessage("画像"),
    "in_key": MessageLookupByLibrary.simpleMessage("中"),
    "inactive_logout": MessageLookupByLibrary.simpleMessage(
      "非アクティブなユーザーのログアウト",
    ),
    "include_number": MessageLookupByLibrary.simpleMessage("数字を含む"),
    "include_special_character": MessageLookupByLibrary.simpleMessage(
      "少なくとも数字、特殊文字、大文字、小文字をそれぞれ1文字ずつ使用してください。",
    ),
    "incorrect_current_password": MessageLookupByLibrary.simpleMessage(
      "現在のパスワードは正しくありません",
    ),
    "incorrect_username": MessageLookupByLibrary.simpleMessage(
      "Eメールまたはパスワードが正しくありません。もう一度試すか、パスワードをリセットしてください。",
    ),
    "invalid_auth_code": MessageLookupByLibrary.simpleMessage(
      "無効な認証コードです。入力したコードを確認して、もう一度お試しください。",
    ),
    "invalid_char": MessageLookupByLibrary.simpleMessage(
      "入力内容が正しくありません。文字、数字、単純な句読点のみを使用してください。",
    ),
    "invalid_char_last_name": MessageLookupByLibrary.simpleMessage(
      "姓に特殊文字は使用できません（<、>、{、}など）",
    ),
    "invalid_cnf_new_pass": MessageLookupByLibrary.simpleMessage(
      "確認用パスワードは新しいパスワードと一致する必要があります",
    ),
    "invalid_cnf_pass": MessageLookupByLibrary.simpleMessage(
      "確認パスワードは、作成したパスワードと同じでなければなりません",
    ),
    "invalid_code": MessageLookupByLibrary.simpleMessage(
      "コードが正しくありません。Eメールで受信したコードと正確に同じコードを入力していることを確認してください。",
    ),
    "invalid_confirm_password": MessageLookupByLibrary.simpleMessage(
      "確認パスワードが無効です",
    ),
    "invalid_current_password": MessageLookupByLibrary.simpleMessage(
      "現在のパスワードが無効です",
    ),
    "invalid_date": MessageLookupByLibrary.simpleMessage("無効な日付"),
    "invalid_email": MessageLookupByLibrary.simpleMessage("Eメールが無効です"),
    "invalid_email_id": MessageLookupByLibrary.simpleMessage("Eメールアドレスが無効です"),
    "invalid_ent_code": MessageLookupByLibrary.simpleMessage("入力したコードが無効です"),
    "invalid_first_name": MessageLookupByLibrary.simpleMessage(
      "2文字以上を入力してください。",
    ),
    "invalid_first_name_text": MessageLookupByLibrary.simpleMessage("名が無効です"),
    "invalid_last_name": MessageLookupByLibrary.simpleMessage(
      "2文字以上を入力してください。",
    ),
    "invalid_last_name_text": MessageLookupByLibrary.simpleMessage("姓が無効です"),
    "invalid_name": MessageLookupByLibrary.simpleMessage("名前が無効です"),
    "invalid_new_pass": MessageLookupByLibrary.simpleMessage("新しいパスワードが無効です"),
    "invalid_new_password": MessageLookupByLibrary.simpleMessage(
      "新しいパスワードが無効です",
    ),
    "invalid_pass": MessageLookupByLibrary.simpleMessage("パスワードが無効です"),
    "invalid_ph_no": MessageLookupByLibrary.simpleMessage("電話番号が無効です"),
    "invalid_response": MessageLookupByLibrary.simpleMessage("応答形式が無効です。"),
    "invalid_text": MessageLookupByLibrary.simpleMessage("テキストが無効です"),
    "invalid_user": MessageLookupByLibrary.simpleMessage(
      "招待メールに関連付けられたEメールアドレスを使用していることを確認してください。",
    ),
    "invalid_verification_code": MessageLookupByLibrary.simpleMessage(
      "認証コードが無効です",
    ),
    "iran": MessageLookupByLibrary.simpleMessage("イラン"),
    "iraq": MessageLookupByLibrary.simpleMessage("イラク"),
    "isMinor": MessageLookupByLibrary.simpleMessage("未成年です"),
    "is_off": MessageLookupByLibrary.simpleMessage("オフ"),
    "is_on": MessageLookupByLibrary.simpleMessage("オン"),
    "is_required": MessageLookupByLibrary.simpleMessage("は必須です"),
    "itinerary": MessageLookupByLibrary.simpleMessage("旅程"),
    "itinerary_deleted_success": MessageLookupByLibrary.simpleMessage(
      "旅程が正常に削除されました。",
    ),
    "itinerary_screen": MessageLookupByLibrary.simpleMessage("旅程の画面"),
    "itinerary_tab": MessageLookupByLibrary.simpleMessage("旅程タブ"),
    "its_all_ive_been_thinking_about": MessageLookupByLibrary.simpleMessage(
      "ずっとこのことばかり考えている",
    ),
    "jamaica": MessageLookupByLibrary.simpleMessage("ジャマイカ"),
    "japan": MessageLookupByLibrary.simpleMessage("日本"),
    "keep_customizing": MessageLookupByLibrary.simpleMessage("旅行のカスタマイズを続ける"),
    "keep_customizing_your_trip": MessageLookupByLibrary.simpleMessage(
      "旅行のカスタマイズを続ける 関心のあるものをすべて選択してください。",
    ),
    "landmarks": MessageLookupByLibrary.simpleMessage("観光名所"),
    "language_change_success": MessageLookupByLibrary.simpleMessage(
      "言語が変更されました。",
    ),
    "language_selection_screen": MessageLookupByLibrary.simpleMessage(
      "言語の選択の画面",
    ),
    "lastUpdated": m2,
    "last_name": MessageLookupByLibrary.simpleMessage("姓"),
    "last_name_is_required": MessageLookupByLibrary.simpleMessage(
      "姓は必須フィールドです",
    ),
    "learn_more": MessageLookupByLibrary.simpleMessage("詳細を見る"),
    "left": MessageLookupByLibrary.simpleMessage("左"),
    "let_get_started": MessageLookupByLibrary.simpleMessage("準備を開始する"),
    "let_me_introduce_myself": MessageLookupByLibrary.simpleMessage(
      "はじめまして、私はEVAです。",
    ),
    "lets_get_personal": MessageLookupByLibrary.simpleMessage(
      "お好みに合わせて旅程をカスタマイズしましょう。",
    ),
    "lets_get_personal_info": MessageLookupByLibrary.simpleMessage(
      "より快適なコミュニケーションを実現するため、ご自身についての情報をいつでもお伝えください。",
    ),
    "lets_go": MessageLookupByLibrary.simpleMessage("さあ、次へ進みましょう！"),
    "lets_go_button": MessageLookupByLibrary.simpleMessage("さあ、次へ進みましょう！"),
    "lets_plan_your_trip": MessageLookupByLibrary.simpleMessage(
      "ご旅行のプランを立てましょう。",
    ),
    "lets_setup_account": MessageLookupByLibrary.simpleMessage("アカウントの設定"),
    "liked_the_message": MessageLookupByLibrary.simpleMessage(
      "メッセージに「いいね！」しました",
    ),
    "limit_exceed": MessageLookupByLibrary.simpleMessage(
      "リクエストの最大数に達しました。後ほど、もう一度お試しください。",
    ),
    "limit_exhausted": MessageLookupByLibrary.simpleMessage("上限に達しました"),
    "live_music": MessageLookupByLibrary.simpleMessage("ライブ\n音楽"),
    "loading_wait": MessageLookupByLibrary.simpleMessage("読み込み中、お待ちください"),
    "local_neighborhoods": MessageLookupByLibrary.simpleMessage("地元のエリア"),
    "location": MessageLookupByLibrary.simpleMessage("勤務地"),
    "location_is_invalid": MessageLookupByLibrary.simpleMessage("日付が無効です"),
    "location_is_required": MessageLookupByLibrary.simpleMessage("ロケーションは必須です"),
    "login": MessageLookupByLibrary.simpleMessage("ログイン"),
    "login_btn": MessageLookupByLibrary.simpleMessage("ログイン"),
    "login_fail": MessageLookupByLibrary.simpleMessage("ログインに失敗しました"),
    "login_here": MessageLookupByLibrary.simpleMessage("こちらからログインして続行してください"),
    "login_screen": MessageLookupByLibrary.simpleMessage("ログイン画面"),
    "login_to_view_full_faqs": MessageLookupByLibrary.simpleMessage(
      "すべてのFAQを見るにはログインしてください",
    ),
    "login_to_view_the_complete_list": MessageLookupByLibrary.simpleMessage(
      "完全なリストを見るにはログインしてください",
    ),
    "login_username": MessageLookupByLibrary.simpleMessage("Eメール"),
    "logout": MessageLookupByLibrary.simpleMessage("ログアウト"),
    "logout_confirmation": MessageLookupByLibrary.simpleMessage(
      "本当にログアウトしてよろしいですか？",
    ),
    "looking_forward_to_it": MessageLookupByLibrary.simpleMessage("楽しみにしている"),
    "low": MessageLookupByLibrary.simpleMessage("L："),
    "low_text": MessageLookupByLibrary.simpleMessage("低"),
    "mali": MessageLookupByLibrary.simpleMessage("マリ"),
    "manage_history": MessageLookupByLibrary.simpleMessage("履歴の管理"),
    "match_city": MessageLookupByLibrary.simpleMessage("試合会場の都市"),
    "match_day": MessageLookupByLibrary.simpleMessage("試合日"),
    "match_is_in_progress": MessageLookupByLibrary.simpleMessage("現在進行中"),
    "match_list_error": MessageLookupByLibrary.simpleMessage("試合が選択されていません"),
    "match_officially_begun": MessageLookupByLibrary.simpleMessage("正式にスタート！"),
    "match_thanks_joining": MessageLookupByLibrary.simpleMessage(
      "ご利用ありがとうございます。",
    ),
    "match_ticket": MessageLookupByLibrary.simpleMessage("チケット"),
    "max_attempts_exceeded": MessageLookupByLibrary.simpleMessage(
      "最大試行回数を超えました",
    ),
    "meh": MessageLookupByLibrary.simpleMessage("それほど興味はありません"),
    "menu": MessageLookupByLibrary.simpleMessage("メニュー"),
    "message_received": MessageLookupByLibrary.simpleMessage("メッセージを受信しました"),
    "message_sent": MessageLookupByLibrary.simpleMessage("メッセージが送信されました"),
    "messages": MessageLookupByLibrary.simpleMessage("メッセージ"),
    "mexico": MessageLookupByLibrary.simpleMessage("メキシコ"),
    "mfa_auth": MessageLookupByLibrary.simpleMessage("多要素認証（MFA）"),
    "mfa_authentication": MessageLookupByLibrary.simpleMessage("MFA認証"),
    "mfa_disable_error": MessageLookupByLibrary.simpleMessage(
      "MFAの無効化に失敗しました。再試行してください。",
    ),
    "mfa_disable_success": MessageLookupByLibrary.simpleMessage(
      "多要素認証が正常に無効化されました。",
    ),
    "mfa_enable_error": MessageLookupByLibrary.simpleMessage(
      "MFAの有効化に失敗しました。再試行してください。",
    ),
    "mfa_enable_success": MessageLookupByLibrary.simpleMessage(
      "多要素認証が正常に有効化されました。",
    ),
    "mins": MessageLookupByLibrary.simpleMessage("分"),
    "minutes": MessageLookupByLibrary.simpleMessage("分"),
    "miscellaneous": MessageLookupByLibrary.simpleMessage("その他"),
    "missed_match_ticket": MessageLookupByLibrary.simpleMessage(
      "期限を過ぎたため、この試合は観戦できません。",
    ),
    "more_details": MessageLookupByLibrary.simpleMessage("さらに表示"),
    "more_details_button": MessageLookupByLibrary.simpleMessage("詳細ボタン、展開"),
    "more_details_link": MessageLookupByLibrary.simpleMessage("詳細リンク、すべて表示"),
    "more_information": MessageLookupByLibrary.simpleMessage("で詳細情報をご覧ください。"),
    "morning": MessageLookupByLibrary.simpleMessage("午前中"),
    "morocco": MessageLookupByLibrary.simpleMessage("モロッコ"),
    "multi_factor_authentication": MessageLookupByLibrary.simpleMessage(
      "多要素認証",
    ),
    "museums": MessageLookupByLibrary.simpleMessage("美術館"),
    "must_see_attractions": MessageLookupByLibrary.simpleMessage("必見のアトラクション"),
    "my_companion_has_given": MessageLookupByLibrary.simpleMessage(
      "Visa Go内で試合情報を入手するために、同伴者から氏名とEメールアドレスを共有する許可を得ています。*",
    ),
    "my_team": MessageLookupByLibrary.simpleMessage("マイ\nチーム"),
    "my_ticket": MessageLookupByLibrary.simpleMessage("マイチケット\n"),
    "name": MessageLookupByLibrary.simpleMessage("氏名"),
    "near_stadium": MessageLookupByLibrary.simpleMessage("スタジアムの近くにある"),
    "netherlands": MessageLookupByLibrary.simpleMessage("オランダ"),
    "new_pass": MessageLookupByLibrary.simpleMessage("新しいパスワード"),
    "new_password_is_required": MessageLookupByLibrary.simpleMessage(
      "新しいパスワードを入力してください",
    ),
    "new_zealand": MessageLookupByLibrary.simpleMessage("ニュージーランド"),
    "next": MessageLookupByLibrary.simpleMessage("次へ"),
    "next_day": MessageLookupByLibrary.simpleMessage("次の日"),
    "next_month": MessageLookupByLibrary.simpleMessage("次の月"),
    "next_week": MessageLookupByLibrary.simpleMessage("次の週"),
    "next_year": MessageLookupByLibrary.simpleMessage("次の年"),
    "nigeria": MessageLookupByLibrary.simpleMessage("ナイジェリア"),
    "night": MessageLookupByLibrary.simpleMessage("夜"),
    "nightlife": MessageLookupByLibrary.simpleMessage("ナイトライフ"),
    "nights": MessageLookupByLibrary.simpleMessage("宿泊数"),
    "no_change_detected_message_in_form": MessageLookupByLibrary.simpleMessage(
      "変更が検出されませんでした。続行するにはフォームを更新してください。",
    ),
    "no_change_detected_message_in_language":
        MessageLookupByLibrary.simpleMessage(
          "変更が検出されませんでした。続行するには言語を更新してください。",
        ),
    "no_change_in_event": MessageLookupByLibrary.simpleMessage(
      "イベントを更新するための変更が行われていません。",
    ),
    "no_changes_detected": MessageLookupByLibrary.simpleMessage(
      "変更は検出されませんでした",
    ),
    "no_event_for_day": MessageLookupByLibrary.simpleMessage(
      "スケジュールされたイベントはありません。ご旅行を予約するか、イベントを追加して旅程を作成しましょう。",
    ),
    "no_image_available": MessageLookupByLibrary.simpleMessage("画像がありません"),
    "no_image_available_for": MessageLookupByLibrary.simpleMessage(
      "次の画像がありません",
    ),
    "no_internet": MessageLookupByLibrary.simpleMessage("インターネットに接続されていません"),
    "no_internet_connect": MessageLookupByLibrary.simpleMessage(
      "インターネットに接続できません",
    ),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "インターネットに接続されていません。",
    ),
    "no_match_ticket_message": MessageLookupByLibrary.simpleMessage(
      "表示する試合がありません。",
    ),
    "no_notification": MessageLookupByLibrary.simpleMessage(
      "すべての情報が最新の状態に更新されています。新しい通知がここに表示されます。",
    ),
    "no_preference": MessageLookupByLibrary.simpleMessage("希望なし"),
    "no_team_found": MessageLookupByLibrary.simpleMessage("次で始まるチームは見つかりません:"),
    "no_tickets_semantics": MessageLookupByLibrary.simpleMessage(
      "チケットの詳細情報セクション。現在、割り当てられているチケットはありません。",
    ),
    "non_editable": MessageLookupByLibrary.simpleMessage("編集不可"),
    "north_macedonia": MessageLookupByLibrary.simpleMessage("北マケドニア共和国"),
    "north_mocedania": MessageLookupByLibrary.simpleMessage("北マケドニア共和国"),
    "not_found": MessageLookupByLibrary.simpleMessage("見つかりません"),
    "notes": MessageLookupByLibrary.simpleMessage("注"),
    "nothing_to_see_here": MessageLookupByLibrary.simpleMessage("情報がありません"),
    "notification_count": m3,
    "notification_status": MessageLookupByLibrary.simpleMessage("通知のステータス"),
    "notification_tab": MessageLookupByLibrary.simpleMessage("通知タブ"),
    "notifications": MessageLookupByLibrary.simpleMessage("通知"),
    "notifications_disable_error": MessageLookupByLibrary.simpleMessage(
      "通知の無効化に失敗しました。再試行してください。",
    ),
    "notifications_disable_success": MessageLookupByLibrary.simpleMessage(
      "通知が正常に無効化されました。",
    ),
    "notifications_enable_error": MessageLookupByLibrary.simpleMessage(
      "通知の有効化に失敗しました。再試行してください。",
    ),
    "notifications_enable_success": MessageLookupByLibrary.simpleMessage(
      "通知が正常に有効化されました。",
    ),
    "now_update_ur_pass": MessageLookupByLibrary.simpleMessage(
      "次に、パスワードを更新します。",
    ),
    "null_ai_response": MessageLookupByLibrary.simpleMessage("無効なAIの応答"),
    "of_question": MessageLookupByLibrary.simpleMessage("の"),
    "off_the_beaten_path": MessageLookupByLibrary.simpleMessage(
      "観光客の少ない穴場スポットにある",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("はい"),
    "on": MessageLookupByLibrary.simpleMessage("オン"),
    "on_booking_you_will": MessageLookupByLibrary.simpleMessage(
      "Booking.comで、コードを貼り付けるよう求められます。2026年7月31日にVisa Goアプリへのアクセス期限が切れる前に、トラベルクレジットをBooking.comのウォレットに追加する必要があります。",
    ),
    "once_you_add_your": MessageLookupByLibrary.simpleMessage(
      "いったんBooking.comのウォレットにトラベルクレジットを追加すると、これらの残高に有効期限はないため、いつでもご旅行にお使いいただけます。",
    ),
    "one_of_four": MessageLookupByLibrary.simpleMessage("4 分の 1"),
    "oops": MessageLookupByLibrary.simpleMessage("申し訳ございません"),
    "open_app_store": MessageLookupByLibrary.simpleMessage("App Storeを開く"),
    "open_book_travel": MessageLookupByLibrary.simpleMessage("ご旅行の予約"),
    "open_companion": MessageLookupByLibrary.simpleMessage("同伴者"),
    "open_eva_chat": MessageLookupByLibrary.simpleMessage("EVAチャット"),
    "open_faq": MessageLookupByLibrary.simpleMessage("よくある質問を開く"),
    "open_in_external_browser": MessageLookupByLibrary.simpleMessage(
      "外部ブラウザで開く",
    ),
    "open_in_maps": MessageLookupByLibrary.simpleMessage("マップで開く"),
    "open_now": MessageLookupByLibrary.simpleMessage("今すぐ開く"),
    "open_on_booking": MessageLookupByLibrary.simpleMessage("Booking.comで開く"),
    "open_play_store": MessageLookupByLibrary.simpleMessage("Play Storeを開く"),
    "open_prepaid_card": MessageLookupByLibrary.simpleMessage("プリペイドカード"),
    "open_profile": MessageLookupByLibrary.simpleMessage("プロフィールに移動する"),
    "open_setting": MessageLookupByLibrary.simpleMessage("設定を開く"),
    "open_ticket": MessageLookupByLibrary.simpleMessage("チケットへ移動する"),
    "open_wallet": MessageLookupByLibrary.simpleMessage("ウォレットを開く"),
    "opt_language": MessageLookupByLibrary.simpleMessage("法的なオプトイン"),
    "optional": MessageLookupByLibrary.simpleMessage("オプション"),
    "orchestrate_authentication_failed": MessageLookupByLibrary.simpleMessage(
      "認証のオーケストレーションに失敗しました",
    ),
    "other_booking_questions": m4,
    "other_ticket_question_title": MessageLookupByLibrary.simpleMessage(
      "その他のチケットに関する質問",
    ),
    "otp_expired": MessageLookupByLibrary.simpleMessage(
      "コードは期限切れです。コードを再送信してください",
    ),
    "our_faqs": MessageLookupByLibrary.simpleMessage("よくあるご質問"),
    "panama": MessageLookupByLibrary.simpleMessage("パナマ"),
    "parks_and_gardens": MessageLookupByLibrary.simpleMessage("公園や庭園"),
    "pass_change_succ": MessageLookupByLibrary.simpleMessage(
      "パスワードの変更が完了しました。ログインして続行してください",
    ),
    "pass_x": MessageLookupByLibrary.simpleMessage("xxxxxx"),
    "password": MessageLookupByLibrary.simpleMessage("パスワード"),
    "password_change_success": MessageLookupByLibrary.simpleMessage(
      "パスワードが正常に更新されました",
    ),
    "password_hidden": MessageLookupByLibrary.simpleMessage("パスワードを非表示"),
    "password_is_required": MessageLookupByLibrary.simpleMessage(
      "パスワードを入力してください",
    ),
    "password_reset_required": MessageLookupByLibrary.simpleMessage(
      "パスワードをリセットしてください。「パスワードを記憶しない」をクリックして続行してください。",
    ),
    "password_reset_successfully": MessageLookupByLibrary.simpleMessage(
      "パスワードのリセットに成功しました",
    ),
    "password_star": MessageLookupByLibrary.simpleMessage("パスワード*"),
    "password_visible": MessageLookupByLibrary.simpleMessage("パスワードを表示"),
    "past_time": MessageLookupByLibrary.simpleMessage("イベントを過去に予定することはできません。"),
    "personal_preferences": MessageLookupByLibrary.simpleMessage("個人的なお気に入り"),
    "peru": MessageLookupByLibrary.simpleMessage("ペルー"),
    "ph_number": MessageLookupByLibrary.simpleMessage("電話番号"),
    "phone_number": MessageLookupByLibrary.simpleMessage("電話番号"),
    "place_name": MessageLookupByLibrary.simpleMessage("場所の名前"),
    "plan_your_trip": MessageLookupByLibrary.simpleMessage("旅行を計画する"),
    "plan_your_trip_info": MessageLookupByLibrary.simpleMessage(
      "夢の旅程を実現しましょう。目的地はどこで、どなたとお出かけですか？ すべての手順をお手伝いさせていただきます。",
    ),
    "playoff_underway": MessageLookupByLibrary.simpleMessage("プレーオフが現在進行中です"),
    "please_acknowledge_all": MessageLookupByLibrary.simpleMessage(
      "続行する前に、すべての必要な利用規約に同意してください。",
    ),
    "please_check_your_email": MessageLookupByLibrary.simpleMessage(
      "招待メールに関連付けられた正しいEメールアドレス*****を使用していることを確認してください。",
    ),
    "please_enter_the_verification_code": MessageLookupByLibrary.simpleMessage(
      "Eメールで受信した認証コードを入力してから、パスワードを更新してください。",
    ),
    "please_login_to_continue": MessageLookupByLibrary.simpleMessage(
      "再度ログインして続行してください。",
    ),
    "please_select_rating": MessageLookupByLibrary.simpleMessage("評価を選択してください"),
    "poland": MessageLookupByLibrary.simpleMessage("ポーランド"),
    "pool": MessageLookupByLibrary.simpleMessage("プール付き"),
    "popular_social_media_photo_opps": MessageLookupByLibrary.simpleMessage(
      "ソーシャルメディアで人気のあるSNS映えする場所",
    ),
    "portugal": MessageLookupByLibrary.simpleMessage("ポルトガル"),
    "prepaid_card": MessageLookupByLibrary.simpleMessage("プリペイドカード"),
    "prepaid_card_package": MessageLookupByLibrary.simpleMessage("プリペイドカード"),
    "prepaid_card_support": MessageLookupByLibrary.simpleMessage(
      "プリペイドカードのサポート",
    ),
    "prepaid_cards": MessageLookupByLibrary.simpleMessage("プリペイドカード"),
    "preparing_match_description": MessageLookupByLibrary.simpleMessage(
      "会場には早めにご到着ください。",
    ),
    "preparing_match_postlink": MessageLookupByLibrary.simpleMessage(
      "手荷物の数量やキャリーケース使用の有無など、制限事項を確認します。",
    ),
    "preparing_match_title": MessageLookupByLibrary.simpleMessage("試合に向けての準備"),
    "pretty_pumped": MessageLookupByLibrary.simpleMessage("とても楽しみにしている"),
    "previous_day": MessageLookupByLibrary.simpleMessage("前の日"),
    "previous_month": MessageLookupByLibrary.simpleMessage("前の月"),
    "previous_week": MessageLookupByLibrary.simpleMessage("前の週"),
    "previous_year": MessageLookupByLibrary.simpleMessage("前の年"),
    "price": m5,
    "price_for": MessageLookupByLibrary.simpleMessage("料金"),
    "primary_type": MessageLookupByLibrary.simpleMessage("プライマリータイプ"),
    "primary_user_cannot_be_a_companion": MessageLookupByLibrary.simpleMessage(
      "プライマリユーザーは同伴者にできません",
    ),
    "privacyPrivacy": MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
    "privacy_notice": MessageLookupByLibrary.simpleMessage("プライバシー通知"),
    "privacy_policy": MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
    "problem_processing": MessageLookupByLibrary.simpleMessage(
      "申し訳ありません。リクエスト処理中に問題が発生しました。再試行してください。",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("処理中..."),
    "profile": MessageLookupByLibrary.simpleMessage("プロフィール"),
    "profile_already_exists": MessageLookupByLibrary.simpleMessage(
      "このユーザーのプロフィールはすでに存在します",
    ),
    "profile_tab": MessageLookupByLibrary.simpleMessage("プロフィールタブ"),
    "profile_text": MessageLookupByLibrary.simpleMessage("プロフィール"),
    "profile_updated": MessageLookupByLibrary.simpleMessage("プロフィールが更新されました"),
    "profile_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "プロフィールが更新されました",
    ),
    "push_notifications": MessageLookupByLibrary.simpleMessage("プッシュ通知"),
    "qatar": MessageLookupByLibrary.simpleMessage("カタール"),
    "question": MessageLookupByLibrary.simpleMessage("質問"),
    "rate_eva_response": MessageLookupByLibrary.simpleMessage("EVAの応答を評価"),
    "rate_us": MessageLookupByLibrary.simpleMessage("評価をつける"),
    "rate_visa_go": MessageLookupByLibrary.simpleMessage("Visa Goを評価する"),
    "rate_visa_go_app": MessageLookupByLibrary.simpleMessage("Visa Goアプリを評価する"),
    "rating": MessageLookupByLibrary.simpleMessage("評価"),
    "reSend_code": MessageLookupByLibrary.simpleMessage("コードを再送信"),
    "read": MessageLookupByLibrary.simpleMessage("読む"),
    "read_more": MessageLookupByLibrary.simpleMessage("続きを読む"),
    "read_notifications": MessageLookupByLibrary.simpleMessage("通知を読む"),
    "receiver_message": MessageLookupByLibrary.simpleMessage("受信者のメッセージ"),
    "recent_queries": MessageLookupByLibrary.simpleMessage("最近のクエリ"),
    "recents": MessageLookupByLibrary.simpleMessage("最近の項目"),
    "redeem_date": MessageLookupByLibrary.simpleMessage("有効期限：2026年7月31日"),
    "redeem_your_travel_credit": MessageLookupByLibrary.simpleMessage(
      "トラベルクレジットを交換する ",
    ),
    "redeem_your_travel_credit2": MessageLookupByLibrary.simpleMessage(
      "トラベルクレジットを\n交換する",
    ),
    "redirect_app_store": MessageLookupByLibrary.simpleMessage(
      "App Storeに移動中です。",
    ),
    "redirect_play_store": MessageLookupByLibrary.simpleMessage(
      "Play Storeに移動中です。",
    ),
    "redirect_to_visa_go_website": MessageLookupByLibrary.simpleMessage(
      "Visa Go webサイトへ移動しています",
    ),
    "redirected_screen": MessageLookupByLibrary.simpleMessage("移動画面"),
    "registered_email": MessageLookupByLibrary.simpleMessage("登録済みのメールアドレス"),
    "registered_email_screen": MessageLookupByLibrary.simpleMessage(
      "登録Eメールの画面",
    ),
    "remind_me_later": MessageLookupByLibrary.simpleMessage("後で通知"),
    "reminder_message": MessageLookupByLibrary.simpleMessage(
      "チケットにアクセスするには、\n次を使用してFIFAアプリで登録する必要があります：",
    ),
    "reminder_title": MessageLookupByLibrary.simpleMessage("お知らせ"),
    "removed_dislike": MessageLookupByLibrary.simpleMessage("「低評価」を取り消しました"),
    "removed_like": MessageLookupByLibrary.simpleMessage("「いいね！」を取り消しました"),
    "required_field": MessageLookupByLibrary.simpleMessage("* 必須項目"),
    "resend_companion_invite": MessageLookupByLibrary.simpleMessage(
      "同伴者の招待を再送信する",
    ),
    "reset_password": MessageLookupByLibrary.simpleMessage("パスワードをリセット"),
    "restaurant_on_the_property": MessageLookupByLibrary.simpleMessage(
      "レストランが併設されている",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("再試行"),
    "return_text": MessageLookupByLibrary.simpleMessage("戻る"),
    "review_our": MessageLookupByLibrary.simpleMessage("以下を確認する"),
    "reviews": MessageLookupByLibrary.simpleMessage("レビュー"),
    "revisit_visa_go": MessageLookupByLibrary.simpleMessage(
      "Visa Goのイントロを再度見る",
    ),
    "rewatch_tutorial": MessageLookupByLibrary.simpleMessage("チュートリアルをもう一度見る"),
    "right": MessageLookupByLibrary.simpleMessage("右"),
    "san_francisco_bay_area": MessageLookupByLibrary.simpleMessage(
      "米国カリフォルニア州 サンフランシスコ、ベイエリア",
    ),
    "saudi_arabia": MessageLookupByLibrary.simpleMessage("サウジアラビア"),
    "save": MessageLookupByLibrary.simpleMessage("保存する"),
    "scenic_nature_spots": MessageLookupByLibrary.simpleMessage("景色の良い自然"),
    "search_team": MessageLookupByLibrary.simpleMessage("チームを検索"),
    "searching": MessageLookupByLibrary.simpleMessage("検索中..."),
    "security_settings": MessageLookupByLibrary.simpleMessage("セキュリティ設定"),
    "security_warning": MessageLookupByLibrary.simpleMessage("セキュリティ警告"),
    "security_warning_message": MessageLookupByLibrary.simpleMessage(
      "セキュリティ上の理由により、このURLは許可されていません。HTTPS URLと信頼できるドメインのみが許可されています。",
    ),
    "see": MessageLookupByLibrary.simpleMessage("以下をご覧ください "),
    "see_more": MessageLookupByLibrary.simpleMessage("もっと見る"),
    "see_our": MessageLookupByLibrary.simpleMessage("以下の "),
    "select_all_that": MessageLookupByLibrary.simpleMessage(
      "該当するものをすべて選択してください。1つの試合につき、同伴者1名様をお連れいただけます。",
    ),
    "select_all_the_interest_you": MessageLookupByLibrary.simpleMessage(
      "当てはまるものをすべて選択してください。",
    ),
    "select_conversation": MessageLookupByLibrary.simpleMessage(
      "再訪問するコンバージョンを選択するか、履歴の管理にアクセスします",
    ),
    "select_conversation_delete": MessageLookupByLibrary.simpleMessage(
      "削除するコンバージョンを選択します。",
    ),
    "select_interest_message": MessageLookupByLibrary.simpleMessage(
      "関心のあるものすべてを選択するか、チャットバーに入力してください。",
    ),
    "selected": MessageLookupByLibrary.simpleMessage("選択済み"),
    "self_companion_not_allowed": MessageLookupByLibrary.simpleMessage(
      "ユーザーは自分自身をコンパニオンとして追加できません。",
    ),
    "send": MessageLookupByLibrary.simpleMessage("送信"),
    "send_auth_code": MessageLookupByLibrary.simpleMessage(
      "Eメールアドレス宛に認証コードをお送りします。",
    ),
    "send_code": MessageLookupByLibrary.simpleMessage("コードを送信"),
    "sender_message": MessageLookupByLibrary.simpleMessage("差出人のメッセージ"),
    "senegal": MessageLookupByLibrary.simpleMessage("セネガル"),
    "serbia": MessageLookupByLibrary.simpleMessage("セルビア"),
    "session_expiring_soon": MessageLookupByLibrary.simpleMessage(
      "セッションがまもなく終了します。",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "setup_account": MessageLookupByLibrary.simpleMessage("次に、アカウントを設定します。"),
    "seven_day_forecast_for": MessageLookupByLibrary.simpleMessage("7日間の天気予報"),
    "share_thoughts": MessageLookupByLibrary.simpleMessage(
      "ご意見・ご感想をここに記入してください",
    ),
    "shopping_centers": MessageLookupByLibrary.simpleMessage("ショッピングセンター"),
    "shopping_districts": MessageLookupByLibrary.simpleMessage("ショッピング街"),
    "sightseeing": MessageLookupByLibrary.simpleMessage("観光"),
    "signIn": MessageLookupByLibrary.simpleMessage("サインイン"),
    "sign_up_screen": MessageLookupByLibrary.simpleMessage("サインアップ画面"),
    "signed_out_due_to_inactivity": MessageLookupByLibrary.simpleMessage(
      "ユーザーの操作が行われなかったため、サインアウトされました",
    ),
    "signout": MessageLookupByLibrary.simpleMessage("サインアウト"),
    "signup": MessageLookupByLibrary.simpleMessage("サインアップ"),
    "skip": MessageLookupByLibrary.simpleMessage("スキップ"),
    "slider_hint_app": MessageLookupByLibrary.simpleMessage(
      "画面の任意の場所をタップするか、スライダーをドラッグして興奮レベルを調整します",
    ),
    "slider_hint_web": MessageLookupByLibrary.simpleMessage(
      "画面の任意の場所をクリックするか、スライダーをドラッグして興奮レベルを調整します",
    ),
    "slightly_excited": MessageLookupByLibrary.simpleMessage("やや楽しみにしている"),
    "so_hyped": MessageLookupByLibrary.simpleMessage("楽しみ過ぎて、言葉に表すことができません。"),
    "something_went_wrong": MessageLookupByLibrary.simpleMessage("問題が発生しました"),
    "something_went_wrong_vpn_issue": MessageLookupByLibrary.simpleMessage(
      "問題が発生しました VPNプロフィールを確認してください",
    ),
    "sorry_missed_mark": MessageLookupByLibrary.simpleMessage(
      "ご不便をおかけしましたことを\nお詫びいたします。",
    ),
    "source": MessageLookupByLibrary.simpleMessage("出典"),
    "south_korea": MessageLookupByLibrary.simpleMessage("大韓民国"),
    "spain": MessageLookupByLibrary.simpleMessage("スペイン"),
    "splash_screen": MessageLookupByLibrary.simpleMessage("スプラッシュ画面"),
    "start": MessageLookupByLibrary.simpleMessage("開始する"),
    "start_new_chat": MessageLookupByLibrary.simpleMessage("新規のチャットを開始"),
    "start_time_field": MessageLookupByLibrary.simpleMessage("開始時間"),
    "start_time_is_invalid": MessageLookupByLibrary.simpleMessage("開始時間が無効です"),
    "start_time_is_required": MessageLookupByLibrary.simpleMessage("開始時間は必須です"),
    "start_time_occurs": MessageLookupByLibrary.simpleMessage(
      "開始時間は、終了時間よりも前に指定してください。",
    ),
    "stay_signed_in": MessageLookupByLibrary.simpleMessage("サインインした状態を維持する"),
    "stay_your_way": MessageLookupByLibrary.simpleMessage("お気に入りのスタイル"),
    "step": MessageLookupByLibrary.simpleMessage("ステップ"),
    "street_food": MessageLookupByLibrary.simpleMessage("屋台"),
    "submit": MessageLookupByLibrary.simpleMessage("送信"),
    "success": MessageLookupByLibrary.simpleMessage("完了しました"),
    "success_24hrs_clock": MessageLookupByLibrary.simpleMessage(
      "24時間形式の時間が有効化されました。",
    ),
    "suggestion_message": MessageLookupByLibrary.simpleMessage(
      "ご旅行のオプションを推奨したり、試合観戦への旅のあらゆる段階でサポートを提供したりいたします。",
    ),
    "super_excited": MessageLookupByLibrary.simpleMessage("非常に興奮している"),
    "support_links": MessageLookupByLibrary.simpleMessage("サポートのリンク"),
    "sweden": MessageLookupByLibrary.simpleMessage("スウェーデン"),
    "switched_calendar_format": MessageLookupByLibrary.simpleMessage(
      "切り替え後のカレンダーの書式",
    ),
    "switzerland": MessageLookupByLibrary.simpleMessage("スイス"),
    "take_me_to_app_store": MessageLookupByLibrary.simpleMessage(
      "App Storeへ移動する",
    ),
    "take_me_to_play_store": MessageLookupByLibrary.simpleMessage(
      "Play Storeへ移動する",
    ),
    "take_me_to_the_app_store": MessageLookupByLibrary.simpleMessage(
      "App Storeへ移動する",
    ),
    "take_me_to_the_play_store": MessageLookupByLibrary.simpleMessage(
      "Play Storeへ移動する",
    ),
    "tap_for_more_ticket_details": MessageLookupByLibrary.simpleMessage(
      "タップするとチケットの詳細が表示されます。",
    ),
    "tap_or_drag_make_selection": MessageLookupByLibrary.simpleMessage(
      "タップまたはドラッグして選択してください。",
    ),
    "team_want_for_fifa": MessageLookupByLibrary.simpleMessage(
      "FIFAワールドカップ 2026で優勝してほしいチームは？",
    ),
    "tell_us_more": MessageLookupByLibrary.simpleMessage("その他、なんでもお知らせください。"),
    "temp_text": MessageLookupByLibrary.simpleMessage("温度"),
    "temperature": m6,
    "termConditions": MessageLookupByLibrary.simpleMessage("利用規約"),
    "terms_and_condition_unselected": MessageLookupByLibrary.simpleMessage(
      "登録を続行するには、利用規約を読み、同意する必要があります。",
    ),
    "text_field": MessageLookupByLibrary.simpleMessage("テキストフィールド"),
    "thanks": MessageLookupByLibrary.simpleMessage("ありがとうございます。"),
    "thanks_feedback": MessageLookupByLibrary.simpleMessage(
      "お客様の貴重なご意見・ご感想は、今後の参考にさせていただきます。",
    ),
    "thanks_for_ur_feedback": MessageLookupByLibrary.simpleMessage(
      "お客様の貴重なご意見・ご感想は、今後の参考にさせていただきます。",
    ),
    "thanks_screen": MessageLookupByLibrary.simpleMessage("感謝画面"),
    "the_match": MessageLookupByLibrary.simpleMessage("試合\n"),
    "theme_parks": MessageLookupByLibrary.simpleMessage("テーマパーク"),
    "thinking": MessageLookupByLibrary.simpleMessage("お待ちください..."),
    "three_of_four": MessageLookupByLibrary.simpleMessage("4 分の 3"),
    "ticket_access": MessageLookupByLibrary.simpleMessage(
      "チケットへのアクセス、目的地への行き方、その他",
    ),
    "ticket_access_info_1": MessageLookupByLibrary.simpleMessage(
      "チケットにアクセスするには、",
    ),
    "ticket_access_info_2": MessageLookupByLibrary.simpleMessage(
      "FIFAアプリで登録する\n必要があります ",
    ),
    "ticket_access_info_3": MessageLookupByLibrary.simpleMessage(
      "その際は、\nこのアプリで使用したのと同じEメールアドレスを使用してください。",
    ),
    "ticket_address": MessageLookupByLibrary.simpleMessage(
      "M14 アルゼンチン vs ドイツ 米国ワシントン州シアトル",
    ),
    "ticket_available_companion": MessageLookupByLibrary.simpleMessage(
      "チケットが入手可能になりました。",
    ),
    "ticket_available_soon_companion": MessageLookupByLibrary.simpleMessage(
      "チケットはまもなく入手可能になります。",
    ),
    "ticket_by_host_avavaible_companion": MessageLookupByLibrary.simpleMessage(
      "招待者に通知が送信されました。\n試合をお楽しみに！",
    ),
    "ticket_can_still_be": MessageLookupByLibrary.simpleMessage(
      "削除してもチケットはFIFAアプリで同伴者に転送することができます。",
    ),
    "ticket_count": m7,
    "ticket_details": MessageLookupByLibrary.simpleMessage("チケットの詳細"),
    "ticket_details_info": MessageLookupByLibrary.simpleMessage(
      "お待たせしました。ここからチケットと試合の詳細情報にアクセスできます。",
    ),
    "ticket_expired_on": MessageLookupByLibrary.simpleMessage("チケットの有効期限："),
    "ticket_get_fifa_app": MessageLookupByLibrary.simpleMessage(
      "FIFAアプリでチケットを入手する",
    ),
    "ticket_match_progress": MessageLookupByLibrary.simpleMessage("現在進行中"),
    "ticket_notifi_when_available_companion":
        MessageLookupByLibrary.simpleMessage("チケットが入手可能になると、\n招待者は通知を受信します。"),
    "ticket_notify_when_available": MessageLookupByLibrary.simpleMessage(
      "FIFAアプリでチケットが入手可能になると\n通知を受け取ります。",
    ),
    "ticket_ready": MessageLookupByLibrary.simpleMessage("チケットのご用意ができました。"),
    "ticket_released_days": MessageLookupByLibrary.simpleMessage(
      "チケットは試合の\n3日前に発行されます。",
    ),
    "ticket_status": MessageLookupByLibrary.simpleMessage("チケットのステータス"),
    "ticket_support": MessageLookupByLibrary.simpleMessage("チケットのサポート"),
    "ticketing_team": MessageLookupByLibrary.simpleMessage(
      "チケットチームまでお問い合わせください。",
    ),
    "tickets": MessageLookupByLibrary.simpleMessage("チケット"),
    "tickets_expired": MessageLookupByLibrary.simpleMessage("チケットが期限切れです"),
    "tickets_tab": MessageLookupByLibrary.simpleMessage("チケットタブ"),
    "tickets_to": MessageLookupByLibrary.simpleMessage("チケット"),
    "time_default": MessageLookupByLibrary.simpleMessage("00:00"),
    "time_remaining_for_world_cup": m8,
    "title": MessageLookupByLibrary.simpleMessage("件名"),
    "title_utc": MessageLookupByLibrary.simpleMessage("UTC"),
    "too_many_attempts": MessageLookupByLibrary.simpleMessage(
      "最大試行回数を超えています。後ほどまたお試しください。",
    ),
    "total_value": MessageLookupByLibrary.simpleMessage("合計価値"),
    "transportation": MessageLookupByLibrary.simpleMessage("交通"),
    "travel_credit": MessageLookupByLibrary.simpleMessage("トラベルクレジット"),
    "travel_credit_starting_value": m9,
    "travel_credits": MessageLookupByLibrary.simpleMessage("トラベルクレジット"),
    "try_again": MessageLookupByLibrary.simpleMessage("再試行してください"),
    "try_again_only": MessageLookupByLibrary.simpleMessage("もう一度お試しください"),
    "tunisia": MessageLookupByLibrary.simpleMessage("チュニジア"),
    "tutorial": MessageLookupByLibrary.simpleMessage("チュートリアル"),
    "tutorial_cancel_button": MessageLookupByLibrary.simpleMessage(
      "チュートリアルのキャンセルボタン",
    ),
    "tutorial_quick_tour": MessageLookupByLibrary.simpleMessage(
      "初めての方はクイックツアーをご覧ください。わずかな手順でVisa Goアプリを簡単に使用できるようになります。",
    ),
    "two_of_four": MessageLookupByLibrary.simpleMessage("4 分の 2"),
    "txt_available": MessageLookupByLibrary.simpleMessage("利用可能"),
    "txt_continue": MessageLookupByLibrary.simpleMessage("続行"),
    "type_here": MessageLookupByLibrary.simpleMessage("入力してください..."),
    "type_here2": MessageLookupByLibrary.simpleMessage("ここに入力してください"),
    "type_here_new": MessageLookupByLibrary.simpleMessage("チームをここに入力"),
    "type_location_here": MessageLookupByLibrary.simpleMessage("ここにロケーションを入力"),
    "type_to_search": MessageLookupByLibrary.simpleMessage("検索ワードを入力"),
    "uae": MessageLookupByLibrary.simpleMessage("アラブ首長国連邦"),
    "ukraine": MessageLookupByLibrary.simpleMessage("ウクライナ"),
    "unchecked": MessageLookupByLibrary.simpleMessage("チェックの解除"),
    "unknown_authentication_error": MessageLookupByLibrary.simpleMessage(
      "不明な認証エラーが発生しました。",
    ),
    "unread": MessageLookupByLibrary.simpleMessage("既読を取り消す"),
    "unread_notifications": MessageLookupByLibrary.simpleMessage("通知の既読を取り消す"),
    "unselected": MessageLookupByLibrary.simpleMessage("選択の解除"),
    "unsupported_device_description": MessageLookupByLibrary.simpleMessage(
      "セキュリティのため、このアプリはルート化または制限解除を行ったデバイスには対応していません。",
    ),
    "unsupported_device_detected": MessageLookupByLibrary.simpleMessage(
      "未対応のデバイスが検出されました",
    ),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "update_": MessageLookupByLibrary.simpleMessage("今すぐアップデート"),
    "update_available": MessageLookupByLibrary.simpleMessage("アップデート可能"),
    "update_language": MessageLookupByLibrary.simpleMessage("言語を更新"),
    "update_message": MessageLookupByLibrary.simpleMessage("メッセージを更新"),
    "update_now": MessageLookupByLibrary.simpleMessage("今すぐアップデート"),
    "update_required": MessageLookupByLibrary.simpleMessage("アップデートが必要です"),
    "upon_deletion_your_companion": MessageLookupByLibrary.simpleMessage(
      "削除した時点で同伴者はチケットへアクセスすることはできなくなりますが、アプリには引き続きアクセスできます。",
    ),
    "url_not_found": MessageLookupByLibrary.simpleMessage("URLが見つかりません"),
    "uruguay": MessageLookupByLibrary.simpleMessage("ウルグアイ"),
    "usa": MessageLookupByLibrary.simpleMessage("USA"),
    "use_navigation_buttons": MessageLookupByLibrary.simpleMessage(
      "ナビゲーションボタンを使用して、月や年を変更できます。",
    ),
    "user_already_exists": MessageLookupByLibrary.simpleMessage(
      "ユーザーはすでに存在します",
    ),
    "user_decline_biometrics": MessageLookupByLibrary.simpleMessage(
      "Face IDを使用するには、iPhoneの設定で生体認証アクセスを有効にしてください。",
    ),
    "user_decline_biometrics_android": MessageLookupByLibrary.simpleMessage(
      "生体認証を使用するには、お使いの電話の設定で生体認証を有効にしてください。",
    ),
    "user_does_not_exist": MessageLookupByLibrary.simpleMessage(
      "招待メールに関連付けられたEメールアドレスを使用していることを確認してください。",
    ),
    "user_is_disable": MessageLookupByLibrary.simpleMessage(
      "アカウントは現在有効ではありません。[VISA support contact TBD]までお問い合わせください。",
    ),
    "user_is_not_confirmed": MessageLookupByLibrary.simpleMessage(
      "ユーザーが確認されていません。",
    ),
    "user_not_found": MessageLookupByLibrary.simpleMessage("ユーザーが見つかりません。"),
    "user_resetPassword": MessageLookupByLibrary.simpleMessage(
      "管理者によりパスワードがリセットされました。「パスワードを記憶しない」をチェックしてから、新しいパスワードを設定します。",
    ),
    "verification": MessageLookupByLibrary.simpleMessage("認証"),
    "verification_code": MessageLookupByLibrary.simpleMessage("認証コード"),
    "verification_code_is_required": MessageLookupByLibrary.simpleMessage(
      "認証コードは必須フィールドです",
    ),
    "verification_code_send_to": m10,
    "verify_mfa": MessageLookupByLibrary.simpleMessage("MFAの確認"),
    "view_and_book_flights": MessageLookupByLibrary.simpleMessage(
      "フライトを表示・予約する",
    ),
    "view_details_about": MessageLookupByLibrary.simpleMessage("次の詳細を見る"),
    "view_full": MessageLookupByLibrary.simpleMessage("全文を表示"),
    "view_full_faqs": MessageLookupByLibrary.simpleMessage("よくある質問の全文を見る"),
    "view_in_apple_wallet": MessageLookupByLibrary.simpleMessage(
      "Apple Walletで表示する",
    ),
    "view_match_ticket": MessageLookupByLibrary.simpleMessage("試合のチケットの詳細を見る"),
    "view_your_balance": MessageLookupByLibrary.simpleMessage(
      "デバイスのウォレットで残高と取引を確認します。",
    ),
    "visa_go": MessageLookupByLibrary.simpleMessage("Visa Go"),
    "visa_go_support": MessageLookupByLibrary.simpleMessage("Visa Go サポート"),
    "visa_logo": MessageLookupByLibrary.simpleMessage("Visaのロゴ"),
    "wales": MessageLookupByLibrary.simpleMessage("ウェールズ"),
    "walking_distance_from_the_match": MessageLookupByLibrary.simpleMessage(
      "試合会場から\n徒歩圏内\n\n",
    ),
    "wallet": MessageLookupByLibrary.simpleMessage("ウォレット"),
    "wallet_info_both": MessageLookupByLibrary.simpleMessage(
      "ご旅行の支払いにトラベルクレジットとプリペイドカードを利用できます。",
    ),
    "wallet_info_prepaid": MessageLookupByLibrary.simpleMessage(
      "ご旅行の支払いにプリペイドカードを利用できます。",
    ),
    "wallet_info_travel_credit": MessageLookupByLibrary.simpleMessage(
      "ご旅行の支払いにトラベルクレジットを利用できます。",
    ),
    "wallet_sub_info_both": MessageLookupByLibrary.simpleMessage(
      "プリペイドカードは、Visa Go内で2026年6月1日〜7月31日の期間にご利用いただけます。",
    ),
    "want_to_delete": MessageLookupByLibrary.simpleMessage("本当に削除してよろしいですか？"),
    "we_sent_an_auth": MessageLookupByLibrary.simpleMessage(
      "Eメールで受信した認証コードを入力してください。",
    ),
    "weather_condition": MessageLookupByLibrary.simpleMessage("天気情報"),
    "welcome": MessageLookupByLibrary.simpleMessage("ようこそ"),
    "welcomeMessage": m11,
    "welcome_back": MessageLookupByLibrary.simpleMessage("おかえりなさい！"),
    "welcome_message": MessageLookupByLibrary.simpleMessage(
      "Visa Goへようこそ。FIFAワールドカップ 2026で、いつまでも忘れられない思い出を作るお手伝いをいたします。",
    ),
    "welcome_message_semantic_label": MessageLookupByLibrary.simpleMessage(
      "Visa Goへようこそ！FIFAワールドカップ26で一生に一度の体験を作るお手伝いをします。",
    ),
    "welcome_please": MessageLookupByLibrary.simpleMessage(
      "ようこそ、Eメールアドレスを入力して続行してください。",
    ),
    "welcome_please_login": MessageLookupByLibrary.simpleMessage(
      "ようこそ、ログインして続行してください。",
    ),
    "welcome_screen": MessageLookupByLibrary.simpleMessage("ようこそ画面"),
    "what_about_my_tickets": MessageLookupByLibrary.simpleMessage(
      "チケットはどうなりますか？",
    ),
    "what_would_you_like": MessageLookupByLibrary.simpleMessage("何をしますか？"),
    "whatsApp": MessageLookupByLibrary.simpleMessage("WhatsApp"),
    "when_you": MessageLookupByLibrary.simpleMessage("ご利用時期 "),
    "where_my_ticket_description": MessageLookupByLibrary.simpleMessage(
      "チケットが利用可能になり次第、通知でお知らせします。試合の48時間前になってもFIFAアプリにチケットが表示されない場合は、以下にお問い合わせください",
    ),
    "where_my_ticket_description_companion": MessageLookupByLibrary.simpleMessage(
      "チケットが入手可能になると招待者宛に通知が送信され、チケットを管理できるようになります。招待者はFIFAアプリで同伴者にチケットを転送することができますが、これは試合会場に別々に入場する場合にのみ必要となるオプションです。試合会場にはできるだけ一緒に入場してください。",
    ),
    "where_my_ticket_title": MessageLookupByLibrary.simpleMessage(
      "チケットはどこで入手できますか？",
    ),
    "which_match_will": MessageLookupByLibrary.simpleMessage(
      "同伴者はどの試合を観戦しますか？",
    ),
    "with_the_same_email": MessageLookupByLibrary.simpleMessage(
      "その際は、Visa Goアプリで使用したのと同じEメールを使用して下さい。チケットは試合の3日前に発行されます。試合の48時間前になってもFIFAアプリにチケットが表示されない場合は、",
    ),
    "worldwide_partner": MessageLookupByLibrary.simpleMessage("ワールドワイドパートナー"),
    "yes_your_can_still": MessageLookupByLibrary.simpleMessage(
      "はい。招待者と共に試合を観戦するか、またはFIFAアプリで招待者からご自身宛にチケットが転送されている場合は、引き続き試合を観戦できます。",
    ),
    "you_are_being": MessageLookupByLibrary.simpleMessage(
      "Booking.comのサポートに移動しています",
    ),
    "you_are_being_redirect": MessageLookupByLibrary.simpleMessage(
      "Booking.comに移動しています このセッションで行われた予約はすべて自動的に、お客様の旅程プログラムに追加されます。",
    ),
    "you_are_being_redirect_booking": MessageLookupByLibrary.simpleMessage(
      "Booking.comに移動しています。",
    ),
    "you_are_being_redirect_to_visa_contact_us_support":
        MessageLookupByLibrary.simpleMessage("VISA GOサポートに移動しています"),
    "you_are_being_to": MessageLookupByLibrary.simpleMessage("次のページへ移動しています "),
    "you_are_being_to_faqs": MessageLookupByLibrary.simpleMessage(
      "よくある質問のページへ移動しています",
    ),
    "you_are_being_to_prepaid": MessageLookupByLibrary.simpleMessage(
      "プリペイドカードのサポートに移動しています",
    ),
    "you_are_being_to_ticket": MessageLookupByLibrary.simpleMessage(
      "チケットのサポートに移動しています",
    ),
    "you_are_going_fifa": MessageLookupByLibrary.simpleMessage(
      "FIFAワールドカップ 2026行きが決定しました",
    ),
    "you_are_nearing_your": MessageLookupByLibrary.simpleMessage(
      "コンパニオンの変更制限に近づいています：",
    ),
    "you_are_now_leaving_visa": MessageLookupByLibrary.simpleMessage(
      "Visaのサイトから移動します",
    ),
    "you_are_now_leaving_visa_go": MessageLookupByLibrary.simpleMessage(
      "Visa Go\nから\n移動しています",
    ),
    "you_can_turn": MessageLookupByLibrary.simpleMessage(
      "このオプションは設定でいつでも有効化・無効化できます。",
    ),
    "you_have_a_travel_credit": MessageLookupByLibrary.simpleMessage(
      "利用できる\nトラベルクレジットがあります",
    ),
    "you_have_received": MessageLookupByLibrary.simpleMessage("新しい通知を受信しました"),
    "you_must_register": MessageLookupByLibrary.simpleMessage(
      "FIFAアプリで登録する必要があります。",
    ),
    "you_need_to_update": MessageLookupByLibrary.simpleMessage(
      "続行するにはアプリをアップデートする必要があります。",
    ),
    "you_reached_the_companion_change": MessageLookupByLibrary.simpleMessage(
      "この試合でのコンパニオン変更の上限に達しました",
    ),
    "you_redirection_fifa": MessageLookupByLibrary.simpleMessage(
      "FIFAへ移動しています。",
    ),
    "you_redirection_maps": MessageLookupByLibrary.simpleMessage("マップへ移動しています"),
    "you_will_be_logged_out": MessageLookupByLibrary.simpleMessage(
      "2分後にログアウトされます。続行するには「サインインした状態を維持する」をクリックしてください。",
    ),
    "you_will_lose_access": MessageLookupByLibrary.simpleMessage(
      "Visa Goアプリへのアクセスは2026年7月31日に期限が切れます。この日付より前にデバイスのウォレットにカードを追加する必要があります。お持ちの資金は2026年12月31日に期限が切れます。",
    ),
    "your_account_has_been_deleted": MessageLookupByLibrary.simpleMessage(
      "アカウントが削除されました。",
    ),
    "your_card_will_be": MessageLookupByLibrary.simpleMessage(
      "お客様のカードは2026年6月1日から利用可能となり、Visaが利用可能な店舗であればどこでもご使用いただけます。",
    ),
    "your_code_was_resent": MessageLookupByLibrary.simpleMessage(
      "コードが再送信されました。",
    ),
    "your_fifa_word_cup_tickets_still_yours":
        MessageLookupByLibrary.simpleMessage(
          "FIFAワールドカップチケットはまだお客様のものです。チケットにアクセスするには、",
        ),
    "your_name_initial": MessageLookupByLibrary.simpleMessage("お名前のイニシャル"),
    "your_package_includes": MessageLookupByLibrary.simpleMessage(
      "パッケージには以下が含まれます：",
    ),
    "your_registered_email": MessageLookupByLibrary.simpleMessage("登録されたEメール"),
    "your_session_has": MessageLookupByLibrary.simpleMessage(
      "セッションが期限切れです。再度ログインしてください。",
    ),
    "your_wallet": MessageLookupByLibrary.simpleMessage("ウォレット"),
    "zero_colon_format": MessageLookupByLibrary.simpleMessage(
      "24時間形式で時間を選択してください。例：00時00分",
    ),
  };
}
