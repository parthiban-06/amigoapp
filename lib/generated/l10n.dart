// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Visa-DHE`
  String get appTitle {
    return Intl.message(
      'Visa-DHE',
      name: 'appTitle',
      desc: 'The application title',
      args: [],
    );
  }

  /// `Welcome {name}`
  String welcomeMessage(String name) {
    return Intl.message(
      'Welcome $name',
      name: 'welcomeMessage',
      desc: 'Welcome message to greet the user',
      args: [name],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `SignIn`
  String get signIn {
    return Intl.message('SignIn', name: 'signIn', desc: '', args: []);
  }

  /// `Email is required`
  String get email_is_required {
    return Intl.message(
      'Email is required',
      name: 'email_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid input. Use only letters, numbers, and basic punctuation.`
  String get invalid_char {
    return Intl.message(
      'Invalid input. Use only letters, numbers, and basic punctuation.',
      name: 'invalid_char',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least two characters.`
  String get invalid_first_name {
    return Intl.message(
      'Please enter at least two characters.',
      name: 'invalid_first_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least two characters.`
  String get invalid_last_name {
    return Intl.message(
      'Please enter at least two characters.',
      name: 'invalid_last_name',
      desc: '',
      args: [],
    );
  }

  /// `Last name cannot contain special characters like <, >, {, }`
  String get invalid_char_last_name {
    return Intl.message(
      'Last name cannot contain special characters like <, >, {, }',
      name: 'invalid_char_last_name',
      desc: '',
      args: [],
    );
  }

  /// `First name is required`
  String get first_name_is_required {
    return Intl.message(
      'First name is required',
      name: 'first_name_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Verification code is required`
  String get verification_code_is_required {
    return Intl.message(
      'Verification code is required',
      name: 'verification_code_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Last name is required`
  String get last_name_is_required {
    return Intl.message(
      'Last name is required',
      name: 'last_name_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get password_is_required {
    return Intl.message(
      'Password is required',
      name: 'password_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required`
  String get confirm_password_is_required {
    return Intl.message(
      'Confirm password is required',
      name: 'confirm_password_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Please read and accept the Terms and Conditions to proceed with registration.`
  String get terms_and_condition_unselected {
    return Intl.message(
      'Please read and accept the Terms and Conditions to proceed with registration.',
      name: 'terms_and_condition_unselected',
      desc: '',
      args: [],
    );
  }

  /// `Biometric Authentication`
  String get bioAuth {
    return Intl.message(
      'Biometric Authentication',
      name: 'bioAuth',
      desc: '',
      args: [],
    );
  }

  /// `Redeem by 31 July 2026`
  String get redeem_date {
    return Intl.message(
      'Redeem by 31 July 2026',
      name: 'redeem_date',
      desc: '',
      args: [],
    );
  }

  /// `Biometric Enabled Successfully`
  String get bioAuthSuccess {
    return Intl.message(
      'Biometric Enabled Successfully',
      name: 'bioAuthSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication failed. Please try again.`
  String get bioAuthFail {
    return Intl.message(
      'Biometric authentication failed. Please try again.',
      name: 'bioAuthFail',
      desc: '',
      args: [],
    );
  }

  /// `Enable Biometric`
  String get enable_bio {
    return Intl.message(
      'Enable Biometric',
      name: 'enable_bio',
      desc: '',
      args: [],
    );
  }

  /// `Url Not Found`
  String get url_not_found {
    return Intl.message(
      'Url Not Found',
      name: 'url_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Not Found`
  String get not_found {
    return Intl.message('Not Found', name: 'not_found', desc: '', args: []);
  }

  /// `Return`
  String get return_text {
    return Intl.message('Return', name: 'return_text', desc: '', args: []);
  }

  /// `Face ID is now available! Enabling Face ID will give you faster access to your information`
  String get faceIdAvailable {
    return Intl.message(
      'Face ID is now available! Enabling Face ID will give you faster access to your information',
      name: 'faceIdAvailable',
      desc: '',
      args: [],
    );
  }

  /// `You can turn this feature on off at any time under Settings.`
  String get you_can_turn {
    return Intl.message(
      'You can turn this feature on off at any time under Settings.',
      name: 'you_can_turn',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Something went wrong`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Code send`
  String get code_send {
    return Intl.message('Code send', name: 'code_send', desc: '', args: []);
  }

  /// `Password reset successfully`
  String get password_reset_successfully {
    return Intl.message(
      'Password reset successfully',
      name: 'password_reset_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get login_username {
    return Intl.message('Email', name: 'login_username', desc: '', args: []);
  }

  /// `Opt in legal language`
  String get opt_language {
    return Intl.message(
      'Opt in legal language',
      name: 'opt_language',
      desc: '',
      args: [],
    );
  }

  /// `Let's set up your account`
  String get lets_setup_account {
    return Intl.message(
      'Let\'s set up your account',
      name: 'lets_setup_account',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message('First Name', name: 'first_name', desc: '', args: []);
  }

  /// `Last Name`
  String get last_name {
    return Intl.message('Last Name', name: 'last_name', desc: '', args: []);
  }

  /// `isMinor`
  String get isMinor {
    return Intl.message('isMinor', name: 'isMinor', desc: '', args: []);
  }

  /// `Include number`
  String get include_number {
    return Intl.message(
      'Include number',
      name: 'include_number',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Please enter the verification code sent to your email.`
  String get we_sent_an_auth {
    return Intl.message(
      'Please enter the verification code sent to your email.',
      name: 'we_sent_an_auth',
      desc: '',
      args: [],
    );
  }

  /// `Must contain at least 1 of each: number, special character, uppercase letter, lowercase letter`
  String get include_special_character {
    return Intl.message(
      'Must contain at least 1 of each: number, special character, uppercase letter, lowercase letter',
      name: 'include_special_character',
      desc: '',
      args: [],
    );
  }

  /// `By creating an account, you confirm that you have read and agree to our Terms and Conditions & Privacy Notice.`
  String get by_creating_an_account {
    return Intl.message(
      'By creating an account, you confirm that you have read and agree to our Terms and Conditions & Privacy Notice.',
      name: 'by_creating_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, please enter your email to continue.`
  String get welcome_please {
    return Intl.message(
      'Welcome, please enter your email to continue.',
      name: 'welcome_please',
      desc: '',
      args: [],
    );
  }

  /// `Enter your verification code`
  String get enter_your_verification_code {
    return Intl.message(
      'Enter your verification code',
      name: 'enter_your_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termConditions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPrivacy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Your registered email`
  String get your_registered_email {
    return Intl.message(
      'Your registered email',
      name: 'your_registered_email',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive a code?`
  String get did_not_receive_a_code {
    return Intl.message(
      'Didn\'t receive a code?',
      name: 'did_not_receive_a_code',
      desc: '',
      args: [],
    );
  }

  /// `Please check your email to ensure you are using the correct email address***** associated with your invitation.`
  String get please_check_your_email {
    return Intl.message(
      'Please check your email to ensure you are using the correct email address***** associated with your invitation.',
      name: 'please_check_your_email',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(' and ', name: 'and', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `You've reached the limit for requests. Please try again later.`
  String get limit_exceed {
    return Intl.message(
      'You\'ve reached the limit for requests. Please try again later.',
      name: 'limit_exceed',
      desc: '',
      args: [],
    );
  }

  /// `Password minimum 8 characters maximum 20`
  String get at_least_8_characters {
    return Intl.message(
      'Password minimum 8 characters maximum 20',
      name: 'at_least_8_characters',
      desc: '',
      args: [],
    );
  }

  /// `We will send an authentication code to your email.`
  String get send_auth_code {
    return Intl.message(
      'We will send an authentication code to your email.',
      name: 'send_auth_code',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back!`
  String get welcome_back {
    return Intl.message(
      'Welcome back!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Enable double factor authentication`
  String get enable_auth {
    return Intl.message(
      'Enable double factor authentication',
      name: 'enable_auth',
      desc: '',
      args: [],
    );
  }

  /// `Login here to continue`
  String get login_here {
    return Intl.message(
      'Login here to continue',
      name: 'login_here',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email`
  String get invalid_email {
    return Intl.message(
      'Invalid Email',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Password`
  String get invalid_pass {
    return Intl.message(
      'Invalid Password',
      name: 'invalid_pass',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Password Change Successfully, Login to Continue`
  String get pass_change_succ {
    return Intl.message(
      'Password Change Successfully, Login to Continue',
      name: 'pass_change_succ',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `xxxxxx`
  String get pass_x {
    return Intl.message('xxxxxx', name: 'pass_x', desc: '', args: []);
  }

  /// `Enter the code below`
  String get enter_code_below {
    return Intl.message(
      'Enter the code below',
      name: 'enter_code_below',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signout {
    return Intl.message('Sign Out', name: 'signout', desc: '', args: []);
  }

  /// `Enable`
  String get enable {
    return Intl.message('Enable', name: 'enable', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `No Internet Connection`
  String get no_internet_connection {
    return Intl.message(
      'No Internet Connection',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgot_password {
    return Intl.message(
      'Forgot Password',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password? Please enter your email to continue.`
  String get forgot_password_please_ent {
    return Intl.message(
      'Forgot password? Please enter your email to continue.',
      name: 'forgot_password_please_ent',
      desc: '',
      args: [],
    );
  }

  /// `Create an Account? SignUp`
  String get create_acc_signup {
    return Intl.message(
      'Create an Account? SignUp',
      name: 'create_acc_signup',
      desc: '',
      args: [],
    );
  }

  /// `Your code was resent.`
  String get your_code_was_resent {
    return Intl.message(
      'Your code was resent.',
      name: 'your_code_was_resent',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message('Sign Up', name: 'signup', desc: '', args: []);
  }

  /// `Invalid verification code`
  String get invalid_verification_code {
    return Intl.message(
      'Invalid verification code',
      name: 'invalid_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code sent to your email, then update your password.`
  String get please_enter_the_verification_code {
    return Intl.message(
      'Please enter the verification code sent to your email, then update your password.',
      name: 'please_enter_the_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Now, let's set up your account.`
  String get setup_account {
    return Intl.message(
      'Now, let\'s set up your account.',
      name: 'setup_account',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Invalid Name`
  String get invalid_name {
    return Intl.message(
      'Invalid Name',
      name: 'invalid_name',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must be the same as the create password`
  String get invalid_cnf_pass {
    return Intl.message(
      'Confirm password must be the same as the create password',
      name: 'invalid_cnf_pass',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Phone Number`
  String get invalid_ph_no {
    return Intl.message(
      'Invalid Phone Number',
      name: 'invalid_ph_no',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Confirm New Password`
  String get cnf_pass {
    return Intl.message(
      'Confirm New Password',
      name: 'cnf_pass',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get ph_number {
    return Intl.message('Phone Number', name: 'ph_number', desc: '', args: []);
  }

  /// `Incorrect code. Please check that you've entered the code exactly as it appears in your email.`
  String get invalid_code {
    return Intl.message(
      'Incorrect code. Please check that you\'ve entered the code exactly as it appears in your email.',
      name: 'invalid_code',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? SignIn`
  String get have_acc {
    return Intl.message(
      'Already have an account? SignIn',
      name: 'have_acc',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Verification code`
  String get verification_code {
    return Intl.message(
      'Verification code',
      name: 'verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter Code`
  String get ent_code {
    return Intl.message('Enter Code', name: 'ent_code', desc: '', args: []);
  }

  /// `Companion Registration`
  String get companion_registration {
    return Intl.message(
      'Companion Registration',
      name: 'companion_registration',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Enter Code`
  String get invalid_ent_code {
    return Intl.message(
      'Invalid Enter Code',
      name: 'invalid_ent_code',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_pass {
    return Intl.message('New Password', name: 'new_pass', desc: '', args: []);
  }

  /// `Invalid New Password`
  String get invalid_new_pass {
    return Intl.message(
      'Invalid New Password',
      name: 'invalid_new_pass',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Resend code`
  String get reSend_code {
    return Intl.message('Resend code', name: 'reSend_code', desc: '', args: []);
  }

  /// `Send Code`
  String get send_code {
    return Intl.message('Send Code', name: 'send_code', desc: '', args: []);
  }

  /// `Continue`
  String get txt_continue {
    return Intl.message('Continue', name: 'txt_continue', desc: '', args: []);
  }

  /// `Choose Your Language`
  String get choose_language {
    return Intl.message(
      'Choose Your Language',
      name: 'choose_language',
      desc: '',
      args: [],
    );
  }

  /// `Recents`
  String get recents {
    return Intl.message('Recents', name: 'recents', desc: '', args: []);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Good Morning`
  String get good_morning {
    return Intl.message(
      'Good Morning',
      name: 'good_morning',
      desc: '',
      args: [],
    );
  }

  /// `Ask me anything.`
  String get ask_me_anything {
    return Intl.message(
      'Ask me anything.',
      name: 'ask_me_anything',
      desc: '',
      args: [],
    );
  }

  /// `Now, update your password.`
  String get now_update_ur_pass {
    return Intl.message(
      'Now, update your password.',
      name: 'now_update_ur_pass',
      desc: '',
      args: [],
    );
  }

  /// `I can suggest options for travel or help at any phase of your journey to the match!`
  String get suggestion_message {
    return Intl.message(
      'I can suggest options for travel or help at any phase of your journey to the match!',
      name: 'suggestion_message',
      desc: '',
      args: [],
    );
  }

  /// `Type Here...`
  String get type_here {
    return Intl.message('Type Here...', name: 'type_here', desc: '', args: []);
  }

  /// `Morning`
  String get morning {
    return Intl.message('Morning', name: 'morning', desc: '', args: []);
  }

  /// `Afternoon`
  String get afternoon {
    return Intl.message('Afternoon', name: 'afternoon', desc: '', args: []);
  }

  /// `Night`
  String get night {
    return Intl.message('Night', name: 'night', desc: '', args: []);
  }

  /// `Evening`
  String get evening {
    return Intl.message('Evening', name: 'evening', desc: '', args: []);
  }

  /// `What would you like to do?`
  String get what_would_you_like {
    return Intl.message(
      'What would you like to do?',
      name: 'what_would_you_like',
      desc: '',
      args: [],
    );
  }

  /// `Recent Queries`
  String get recent_queries {
    return Intl.message(
      'Recent Queries',
      name: 'recent_queries',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete?`
  String get want_to_delete {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'want_to_delete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Match Ticket/Details`
  String get ftt_match_ticket {
    return Intl.message(
      'Match Ticket/Details',
      name: 'ftt_match_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Match Title`
  String get ftt_title {
    return Intl.message('Match Title', name: 'ftt_title', desc: '', args: []);
  }

  /// `Lorem ipsum dolor sit amet consectetur. Amet tellus justo dignissim urna.`
  String get ftt_match_ticket_desc {
    return Intl.message(
      'Lorem ipsum dolor sit amet consectetur. Amet tellus justo dignissim urna.',
      name: 'ftt_match_ticket_desc',
      desc: '',
      args: [],
    );
  }

  /// `Let's plan your trip.`
  String get lets_plan_your_trip {
    return Intl.message(
      'Let\'s plan your trip.',
      name: 'lets_plan_your_trip',
      desc: '',
      args: [],
    );
  }

  /// `Select a language.`
  String get first_time_pref {
    return Intl.message(
      'Select a language.',
      name: 'first_time_pref',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Enable Biometrics?`
  String get enable_biometric {
    return Intl.message(
      'Enable Biometrics?',
      name: 'enable_biometric',
      desc: '',
      args: [],
    );
  }

  /// `Help protect your account from unauthorized access by requiring a second authentication method in addition to your password.`
  String get help_protect_your_acc {
    return Intl.message(
      'Help protect your account from unauthorized access by requiring a second authentication method in addition to your password.',
      name: 'help_protect_your_acc',
      desc: '',
      args: [],
    );
  }

  /// `Enable Face ID?`
  String get enable_face_id {
    return Intl.message(
      'Enable Face ID?',
      name: 'enable_face_id',
      desc: '',
      args: [],
    );
  }

  /// `User already exists`
  String get user_already_exists {
    return Intl.message(
      'User already exists',
      name: 'user_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations, you're headed to the FIFAWorld Cup™`
  String get congrats_your_heard {
    return Intl.message(
      'Congratulations, you\'re headed to the FIFAWorld Cup™',
      name: 'congrats_your_heard',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Get faster access to your information. You can turn this feature on or off at any time under Profile.`
  String get get_faster_access {
    return Intl.message(
      'Get faster access to your information. You can turn this feature on or off at any time under Profile.',
      name: 'get_faster_access',
      desc: '',
      args: [],
    );
  }

  /// `everywhere you want to be`
  String get everywhere_you_want {
    return Intl.message(
      'everywhere you want to be',
      name: 'everywhere_you_want',
      desc: '',
      args: [],
    );
  }

  /// `Step`
  String get step {
    return Intl.message('Step', name: 'step', desc: '', args: []);
  }

  /// `Log In`
  String get login_btn {
    return Intl.message('Log In', name: 'login_btn', desc: '', args: []);
  }

  /// `Welcome, please log in to continue.`
  String get welcome_please_login {
    return Intl.message(
      'Welcome, please log in to continue.',
      name: 'welcome_please_login',
      desc: '',
      args: [],
    );
  }

  /// `MEH`
  String get meh {
    return Intl.message('MEH', name: 'meh', desc: '', args: []);
  }

  /// `SO hyped. Can't be measured with existing technology.`
  String get so_hyped {
    return Intl.message(
      'SO hyped. Can\'t be measured with existing technology.',
      name: 'so_hyped',
      desc: '',
      args: [],
    );
  }

  /// `Extremely excited!`
  String get excited {
    return Intl.message(
      'Extremely excited!',
      name: 'excited',
      desc: '',
      args: [],
    );
  }

  /// `Thanks,`
  String get thanks {
    return Intl.message('Thanks,', name: 'thanks', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Type Here`
  String get type_here2 {
    return Intl.message('Type Here', name: 'type_here2', desc: '', args: []);
  }

  /// `Your wallet`
  String get your_wallet {
    return Intl.message('Your wallet', name: 'your_wallet', desc: '', args: []);
  }

  /// `Account Settings`
  String get account_settings {
    return Intl.message(
      'Account Settings',
      name: 'account_settings',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get app_settings {
    return Intl.message(
      'App Settings',
      name: 'app_settings',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get change_language {
    return Intl.message(
      'Change Language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect current password`
  String get incorrect_current_password {
    return Intl.message(
      'Incorrect current password',
      name: 'incorrect_current_password',
      desc: '',
      args: [],
    );
  }

  /// `Security Settings`
  String get security_settings {
    return Intl.message(
      'Security Settings',
      name: 'security_settings',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile Details`
  String get edit_profile_details {
    return Intl.message(
      'Edit Profile Details',
      name: 'edit_profile_details',
      desc: '',
      args: [],
    );
  }

  /// `CURRENT PASSWORD`
  String get current_password {
    return Intl.message(
      'CURRENT PASSWORD',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Update Language`
  String get update_language {
    return Intl.message(
      'Update Language',
      name: 'update_language',
      desc: '',
      args: [],
    );
  }

  /// `Profile Updated`
  String get profile_updated {
    return Intl.message(
      'Profile Updated',
      name: 'profile_updated',
      desc: '',
      args: [],
    );
  }

  /// `Add Travel Companion`
  String get add_travel_companion {
    return Intl.message(
      'Add Travel Companion',
      name: 'add_travel_companion',
      desc: '',
      args: [],
    );
  }

  /// `Companion Email`
  String get companion_email {
    return Intl.message(
      'Companion Email',
      name: 'companion_email',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Which matches will your companion attend?*`
  String get which_match_will {
    return Intl.message(
      'Which matches will your companion attend?*',
      name: 'which_match_will',
      desc: '',
      args: [],
    );
  }

  /// `Select all that apply. One Companion per match.`
  String get select_all_that {
    return Intl.message(
      'Select all that apply. One Companion per match.',
      name: 'select_all_that',
      desc: '',
      args: [],
    );
  }

  /// `I acknowledge that adding a companion only provides access to Visa Go. All tickets are issued to me via the FIFA app.*`
  String get i_acknowledge_that {
    return Intl.message(
      'I acknowledge that adding a companion only provides access to Visa Go. All tickets are issued to me via the FIFA app.*',
      name: 'i_acknowledge_that',
      desc: '',
      args: [],
    );
  }

  /// `Adding a companion is optional. Companions will only have access to the Visa Go app. All tickets are issued to your via the FIFA app. You do not have to add a companion in Visa Go in order to take someone to the FIFA World Cup 26™`
  String get adding_a_companion_is_optional {
    return Intl.message(
      'Adding a companion is optional. Companions will only have access to the Visa Go app. All tickets are issued to your via the FIFA app. You do not have to add a companion in Visa Go in order to take someone to the FIFA World Cup 26™',
      name: 'adding_a_companion_is_optional',
      desc: '',
      args: [],
    );
  }

  /// `Push Notifications`
  String get push_notifications {
    return Intl.message(
      'Push Notifications',
      name: 'push_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Delete My Account`
  String get delete_my_account {
    return Intl.message(
      'Delete My Account',
      name: 'delete_my_account',
      desc: '',
      args: [],
    );
  }

  /// `Revisit Visa Go Intro`
  String get revisit_visa_go {
    return Intl.message(
      'Revisit Visa Go Intro',
      name: 'revisit_visa_go',
      desc: '',
      args: [],
    );
  }

  /// `24hr Clock`
  String get hr_clock {
    return Intl.message('24hr Clock', name: 'hr_clock', desc: '', args: []);
  }

  /// `Multi-Factor Authentication`
  String get multi_factor_authentication {
    return Intl.message(
      'Multi-Factor Authentication',
      name: 'multi_factor_authentication',
      desc: '',
      args: [],
    );
  }

  /// `Biometrics`
  String get biometrics {
    return Intl.message('Biometrics', name: 'biometrics', desc: '', args: []);
  }

  /// `Access My Personal Data`
  String get access_my_personal_data {
    return Intl.message(
      'Access My Personal Data',
      name: 'access_my_personal_data',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Ticket Support`
  String get ticket_support {
    return Intl.message(
      'Ticket Support',
      name: 'ticket_support',
      desc: '',
      args: [],
    );
  }

  /// `Booking.com Support`
  String get booking_support {
    return Intl.message(
      'Booking.com Support',
      name: 'booking_support',
      desc: '',
      args: [],
    );
  }

  /// `Booking.com`
  String get booking_com {
    return Intl.message('Booking.com', name: 'booking_com', desc: '', args: []);
  }

  /// `Copy code`
  String get copy_code {
    return Intl.message('Copy code', name: 'copy_code', desc: '', args: []);
  }

  /// `Let's Go!`
  String get lets_go {
    return Intl.message('Let\'s Go!', name: 'lets_go', desc: '', args: []);
  }

  /// `Don't show me this reminder again`
  String get dont_show_me_this {
    return Intl.message(
      'Don\'t show me this reminder again',
      name: 'dont_show_me_this',
      desc: '',
      args: [],
    );
  }

  /// `How to Use`
  String get how_to_use {
    return Intl.message('How to Use', name: 'how_to_use', desc: '', args: []);
  }

  /// `You have a\ntravel credit!`
  String get you_have_a_travel_credit {
    return Intl.message(
      'You have a\ntravel credit!',
      name: 'you_have_a_travel_credit',
      desc: '',
      args: [],
    );
  }

  /// `When you `
  String get when_you {
    return Intl.message('When you ', name: 'when_you', desc: '', args: []);
  }

  /// `Travel credits`
  String get travel_credits {
    return Intl.message(
      'Travel credits',
      name: 'travel_credits',
      desc: '',
      args: [],
    );
  }

  /// `Total value`
  String get total_value {
    return Intl.message('Total value', name: 'total_value', desc: '', args: []);
  }

  /// `Prepaid Cards`
  String get prepaid_cards {
    return Intl.message(
      'Prepaid Cards',
      name: 'prepaid_cards',
      desc: '',
      args: [],
    );
  }

  /// `Check balance`
  String get check_balance {
    return Intl.message(
      'Check balance',
      name: 'check_balance',
      desc: '',
      args: [],
    );
  }

  /// `Book travel`
  String get book_travel2 {
    return Intl.message(
      'Book travel',
      name: 'book_travel2',
      desc: '',
      args: [],
    );
  }

  /// `View your balance and transactions in your device's Wallet.`
  String get view_your_balance {
    return Intl.message(
      'View your balance and transactions in your device\'s Wallet.',
      name: 'view_your_balance',
      desc: '',
      args: [],
    );
  }

  /// `You will lose access to the Visa Go app on 31 July 2026. You must add your card to your device wallet prior to that date. Your funds will expire on 31 December 2026.`
  String get you_will_lose_access {
    return Intl.message(
      'You will lose access to the Visa Go app on 31 July 2026. You must add your card to your device wallet prior to that date. Your funds will expire on 31 December 2026.',
      name: 'you_will_lose_access',
      desc: '',
      args: [],
    );
  }

  /// `Your card will be available beginning 1 June 2026 and can be used anywhere Visa is accepted.`
  String get your_card_will_be {
    return Intl.message(
      'Your card will be available beginning 1 June 2026 and can be used anywhere Visa is accepted.',
      name: 'your_card_will_be',
      desc: '',
      args: [],
    );
  }

  /// `redeem your Travel Credit `
  String get redeem_your_travel_credit {
    return Intl.message(
      'redeem your Travel Credit ',
      name: 'redeem_your_travel_credit',
      desc: '',
      args: [],
    );
  }

  /// `Add to Apple Wallet`
  String get add_to_apple_wallet {
    return Intl.message(
      'Add to Apple Wallet',
      name: 'add_to_apple_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get copied {
    return Intl.message('Copied', name: 'copied', desc: '', args: []);
  }

  /// `You are being redirected to Booking.com. Any bookings from this session will be automatically added to your itinerary.`
  String get you_are_being_redirect {
    return Intl.message(
      'You are being redirected to Booking.com. Any bookings from this session will be automatically added to your itinerary.',
      name: 'you_are_being_redirect',
      desc: '',
      args: [],
    );
  }

  /// `Redeem your\ntravel credits`
  String get redeem_your_travel_credit2 {
    return Intl.message(
      'Redeem your\ntravel credits',
      name: 'redeem_your_travel_credit2',
      desc: '',
      args: [],
    );
  }

  /// `Check current balance on\nBooking.com`
  String get check_current_balance {
    return Intl.message(
      'Check current balance on\nBooking.com',
      name: 'check_current_balance',
      desc: '',
      args: [],
    );
  }

  /// `on Booking.com, you will be prompted to paste your code. You must add your Travel Credit to your Booking.com wallet before you lose access to the Visa Go app on 31 July 2026.`
  String get on_booking_you_will {
    return Intl.message(
      'on Booking.com, you will be prompted to paste your code. You must add your Travel Credit to your Booking.com wallet before you lose access to the Visa Go app on 31 July 2026.',
      name: 'on_booking_you_will',
      desc: '',
      args: [],
    );
  }

  /// `Once you add your Travel Credit to your Booking.com Wallet, those funds never expire and can be used for any travel.`
  String get once_you_add_your {
    return Intl.message(
      'Once you add your Travel Credit to your Booking.com Wallet, those funds never expire and can be used for any travel.',
      name: 'once_you_add_your',
      desc: '',
      args: [],
    );
  }

  /// `For questions, please refer to our `
  String get for_questions {
    return Intl.message(
      'For questions, please refer to our ',
      name: 'for_questions',
      desc: '',
      args: [],
    );
  }

  /// `FAQs.`
  String get our_faqs {
    return Intl.message('FAQs.', name: 'our_faqs', desc: '', args: []);
  }

  /// `See `
  String get see {
    return Intl.message('See ', name: 'see', desc: '', args: []);
  }

  /// `You are now leaving Visa`
  String get you_are_now_leaving_visa {
    return Intl.message(
      'You are now leaving Visa',
      name: 'you_are_now_leaving_visa',
      desc: '',
      args: [],
    );
  }

  /// `Booking.com's Terms & Conditions.`
  String get booking_terms_conditions {
    return Intl.message(
      'Booking.com\'s Terms & Conditions.',
      name: 'booking_terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Prepaid Card Support`
  String get prepaid_card_support {
    return Intl.message(
      'Prepaid Card Support',
      name: 'prepaid_card_support',
      desc: '',
      args: [],
    );
  }

  /// `FAQs`
  String get faqs {
    return Intl.message('FAQs', name: 'faqs', desc: '', args: []);
  }

  /// `Rewatch Tutorial`
  String get rewatch_tutorial {
    return Intl.message(
      'Rewatch Tutorial',
      name: 'rewatch_tutorial',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message('Log Out', name: 'logout', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Rate Us`
  String get rate_us {
    return Intl.message('Rate Us', name: 'rate_us', desc: '', args: []);
  }

  /// `Companion Details`
  String get companion_details {
    return Intl.message(
      'Companion Details',
      name: 'companion_details',
      desc: '',
      args: [],
    );
  }

  /// `Delete your Companion?`
  String get delete_your_companion {
    return Intl.message(
      'Delete your Companion?',
      name: 'delete_your_companion',
      desc: '',
      args: [],
    );
  }

  /// `Tickets can still be transferred to your Companion in the FIFA app.`
  String get ticket_can_still_be {
    return Intl.message(
      'Tickets can still be transferred to your Companion in the FIFA app.',
      name: 'ticket_can_still_be',
      desc: '',
      args: [],
    );
  }

  /// `Upon deletion, your Companion will lose access to the tickets but will still have access to the app.`
  String get upon_deletion_your_companion {
    return Intl.message(
      'Upon deletion, your Companion will lose access to the tickets but will still have access to the app.',
      name: 'upon_deletion_your_companion',
      desc: '',
      args: [],
    );
  }

  /// `Edit Companion`
  String get edit_companion {
    return Intl.message(
      'Edit Companion',
      name: 'edit_companion',
      desc: '',
      args: [],
    );
  }

  /// `Login Fail`
  String get login_fail {
    return Intl.message('Login Fail', name: 'login_fail', desc: '', args: []);
  }

  /// `Check to ensure you are using the email address associated with your invitation.`
  String get invalid_user {
    return Intl.message(
      'Check to ensure you are using the email address associated with your invitation.',
      name: 'invalid_user',
      desc: '',
      args: [],
    );
  }

  /// `MFA Authentication`
  String get mfa_authentication {
    return Intl.message(
      'MFA Authentication',
      name: 'mfa_authentication',
      desc: '',
      args: [],
    );
  }

  /// `Verify MFA`
  String get verify_mfa {
    return Intl.message('Verify MFA', name: 'verify_mfa', desc: '', args: []);
  }

  /// `Verify Email`
  String get email_verification {
    return Intl.message(
      'Verify Email',
      name: 'email_verification',
      desc: '',
      args: [],
    );
  }

  /// `Please try again`
  String get try_again {
    return Intl.message(
      'Please try again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Multi-factor Authentication (MFA)`
  String get mfa_auth {
    return Intl.message(
      'Multi-factor Authentication (MFA)',
      name: 'mfa_auth',
      desc: '',
      args: [],
    );
  }

  /// `Help protect your account from unauthorized access by requiring a second authentication method in addition to your password.`
  String get help_protect_ur_acc {
    return Intl.message(
      'Help protect your account from unauthorized access by requiring a second authentication method in addition to your password.',
      name: 'help_protect_ur_acc',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connected`
  String get no_internet {
    return Intl.message(
      'No Internet Connected',
      name: 'no_internet',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't fetch data.`
  String get connection_refused {
    return Intl.message(
      'Couldn\'t fetch data.',
      name: 'connection_refused',
      desc: '',
      args: [],
    );
  }

  /// `Get ready to explore`
  String get get_ready_to_explore {
    return Intl.message(
      'Get ready to explore',
      name: 'get_ready_to_explore',
      desc: '',
      args: [],
    );
  }

  /// `Invalid response format.`
  String get invalid_response {
    return Intl.message(
      'Invalid response format.',
      name: 'invalid_response',
      desc: '',
      args: [],
    );
  }

  /// `Request timed out.`
  String get api_timeout {
    return Intl.message(
      'Request timed out.',
      name: 'api_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Hi,`
  String get hi {
    return Intl.message('Hi,', name: 'hi', desc: '', args: []);
  }

  /// `SAN FRANCISCO BAY AREA, CA, USA`
  String get san_francisco_bay_area {
    return Intl.message(
      'SAN FRANCISCO BAY AREA, CA, USA',
      name: 'san_francisco_bay_area',
      desc: '',
      args: [],
    );
  }

  /// `GOAL!`
  String get goal {
    return Intl.message('GOAL!', name: 'goal', desc: '', args: []);
  }

  /// `You're going to the FIFA World Cup 26™`
  String get you_are_going_fifa {
    return Intl.message(
      'You\'re going to the FIFA World Cup 26™',
      name: 'you_are_going_fifa',
      desc: '',
      args: [],
    );
  }

  /// `Let's Get Started`
  String get let_get_started {
    return Intl.message(
      'Let\'s Get Started',
      name: 'let_get_started',
      desc: '',
      args: [],
    );
  }

  /// `Let me introduce myself, my name is EVA.`
  String get let_me_introduce_myself {
    return Intl.message(
      'Let me introduce myself, my name is EVA.',
      name: 'let_me_introduce_myself',
      desc: '',
      args: [],
    );
  }

  /// `I'm EVA, here to help you Explore, Voyage, and Access (EVA) everything you want in and around the match.`
  String get i_m_here_to_help {
    return Intl.message(
      'I\'m EVA, here to help you Explore, Voyage, and Access (EVA) everything you want in and around the match.',
      name: 'i_m_here_to_help',
      desc: '',
      args: [],
    );
  }

  /// `A profile for this user already exists`
  String get profile_already_exists {
    return Intl.message(
      'A profile for this user already exists',
      name: 'profile_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `EVA`
  String get eva {
    return Intl.message('EVA', name: 'eva', desc: '', args: []);
  }

  /// `Itinerary`
  String get itinerary {
    return Intl.message('Itinerary', name: 'itinerary', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `How excited are you for the FIFA World Cup 26™?`
  String get how_excited {
    return Intl.message(
      'How excited are you for the FIFA World Cup 26™?',
      name: 'how_excited',
      desc: '',
      args: [],
    );
  }

  /// `What is the GOOAAAAAAAL of your trip?`
  String get goal_of_trip {
    return Intl.message(
      'What is the GOOAAAAAAAL of your trip?',
      name: 'goal_of_trip',
      desc: '',
      args: [],
    );
  }

  /// `What is the goal of your trip?`
  String get goal_of_the_trip {
    return Intl.message(
      'What is the goal of your trip?',
      name: 'goal_of_the_trip',
      desc: '',
      args: [],
    );
  }

  /// `Getting to know screen`
  String get getting_to_konw_screen {
    return Intl.message(
      'Getting to know screen',
      name: 'getting_to_konw_screen',
      desc: '',
      args: [],
    );
  }

  /// `What team do you want to win the FIFA World Cup 26™?`
  String get team_want_for_fifa {
    return Intl.message(
      'What team do you want to win the FIFA World Cup 26™?',
      name: 'team_want_for_fifa',
      desc: '',
      args: [],
    );
  }

  /// `Tap or drag to make your selection.`
  String get tap_or_drag_make_selection {
    return Intl.message(
      'Tap or drag to make your selection.',
      name: 'tap_or_drag_make_selection',
      desc: '',
      args: [],
    );
  }

  /// `Click or drag to make your selection.`
  String get click_or_drag_make_selection {
    return Intl.message(
      'Click or drag to make your selection.',
      name: 'click_or_drag_make_selection',
      desc: '',
      args: [],
    );
  }

  /// `Select all that interest you.`
  String get select_all_the_interest_you {
    return Intl.message(
      'Select all that interest you.',
      name: 'select_all_the_interest_you',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Type Team Here`
  String get type_here_new {
    return Intl.message(
      'Type Team Here',
      name: 'type_here_new',
      desc: '',
      args: [],
    );
  }

  /// `Tickets`
  String get tickets {
    return Intl.message('Tickets', name: 'tickets', desc: '', args: []);
  }

  /// `Search Team`
  String get search_team {
    return Intl.message('Search Team', name: 'search_team', desc: '', args: []);
  }

  /// `Now, let's make this experience all about you. Let's get started in creating your trip!`
  String get i_know_more_about {
    return Intl.message(
      'Now, let\'s make this experience all about you. Let\'s get started in creating your trip!',
      name: 'i_know_more_about',
      desc: '',
      args: [],
    );
  }

  /// `Hello {name}!`
  String helloMessage(String name) {
    return Intl.message(
      'Hello $name!',
      name: 'helloMessage',
      desc: 'Welcome message to greet the user',
      args: [name],
    );
  }

  /// `Hi,{name}!`
  String hiMessage(String name) {
    return Intl.message(
      'Hi,$name!',
      name: 'hiMessage',
      desc: 'Hi message to greet the user',
      args: [name],
    );
  }

  /// `Travel credit starting value {price}. You will be prompted to paste this code on Booking.com`
  String travel_credit_starting_value(String price) {
    return Intl.message(
      'Travel credit starting value $price. You will be prompted to paste this code on Booking.com',
      name: 'travel_credit_starting_value',
      desc: 'Travel credit starting value',
      args: [price],
    );
  }

  /// `Verification code send to {email}`
  String verification_code_send_to(String email) {
    return Intl.message(
      'Verification code send to $email',
      name: 'verification_code_send_to',
      desc: 'Verification message',
      args: [email],
    );
  }

  /// `Last updated: {date}`
  String lastUpdated(DateTime date) {
    final DateFormat dateDateFormat = DateFormat.yMMMMd(
      Intl.getCurrentLocale(),
    );
    final String dateString = dateDateFormat.format(date);

    return Intl.message(
      'Last updated: $dateString',
      name: 'lastUpdated',
      desc: 'Last updated date',
      args: [dateString],
    );
  }

  /// `Price: {price}`
  String price(double price) {
    final NumberFormat priceNumberFormat = NumberFormat.currency(
      locale: Intl.getCurrentLocale(),
      symbol: '\$',
      decimalDigits: 2,
    );
    final String priceString = priceNumberFormat.format(price);

    return Intl.message(
      'Price: $priceString',
      name: 'price',
      desc: 'Price with currency',
      args: [priceString],
    );
  }

  /// `Temperature: {temp}°C`
  String temperature(double temp) {
    final NumberFormat tempNumberFormat = NumberFormat.decimalPattern(
      Intl.getCurrentLocale(),
    );
    final String tempString = tempNumberFormat.format(temp);

    return Intl.message(
      'Temperature: $tempString°C',
      name: 'temperature',
      desc: 'Temperature value',
      args: [tempString],
    );
  }

  /// `Exceptional Eats`
  String get exceptional_menus {
    return Intl.message(
      'Exceptional Eats',
      name: 'exceptional_menus',
      desc: '',
      args: [],
    );
  }

  /// `orchestrate authentication failed`
  String get authentication_failed {
    return Intl.message(
      'orchestrate authentication failed',
      name: 'authentication_failed',
      desc: '',
      args: [],
    );
  }

  /// `Authenticating`
  String get authenticating {
    return Intl.message(
      'Authenticating',
      name: 'authenticating',
      desc: '',
      args: [],
    );
  }

  /// `Good Afternoon`
  String get good_afternoon {
    return Intl.message(
      'Good Afternoon',
      name: 'good_afternoon',
      desc: '',
      args: [],
    );
  }

  /// `Good Evening`
  String get good_evening {
    return Intl.message(
      'Good Evening',
      name: 'good_evening',
      desc: '',
      args: [],
    );
  }

  /// `View your match ticket details`
  String get view_match_ticket {
    return Intl.message(
      'View your match ticket details',
      name: 'view_match_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Ask EVA for travel\nrecommendations`
  String get ask_eva_travel {
    return Intl.message(
      'Ask EVA for travel\nrecommendations',
      name: 'ask_eva_travel',
      desc: '',
      args: [],
    );
  }

  /// `Add your companion`
  String get add_companion {
    return Intl.message(
      'Add your companion',
      name: 'add_companion',
      desc: '',
      args: [],
    );
  }

  /// `Companion`
  String get companion {
    return Intl.message('Companion', name: 'companion', desc: '', args: []);
  }

  /// `Resend Companion Invite`
  String get resend_companion_invite {
    return Intl.message(
      'Resend Companion Invite',
      name: 'resend_companion_invite',
      desc: '',
      args: [],
    );
  }

  /// `Access your wallet`
  String get access_wallet {
    return Intl.message(
      'Access your wallet',
      name: 'access_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Book\ntravel`
  String get book_travel {
    return Intl.message(
      'Book\ntravel',
      name: 'book_travel',
      desc: '',
      args: [],
    );
  }

  /// `The\nMatch`
  String get the_match {
    return Intl.message('The\nMatch', name: 'the_match', desc: '', args: []);
  }

  /// `Match Day`
  String get group_match_day {
    return Intl.message(
      'Match Day',
      name: 'group_match_day',
      desc: '',
      args: [],
    );
  }

  /// `Hotel with\nRestaurant`
  String get hotel_with_restaurant {
    return Intl.message(
      'Hotel with\nRestaurant',
      name: 'hotel_with_restaurant',
      desc: '',
      args: [],
    );
  }

  /// `Stay Your Way`
  String get stay_your_way {
    return Intl.message(
      'Stay Your Way',
      name: 'stay_your_way',
      desc: '',
      args: [],
    );
  }

  /// `Boutique`
  String get boutique {
    return Intl.message('Boutique', name: 'boutique', desc: '', args: []);
  }

  /// `Hidden\nGems`
  String get hidden_gems {
    return Intl.message(
      'Hidden\nGems',
      name: 'hidden_gems',
      desc: '',
      args: [],
    );
  }

  /// `Café`
  String get cafe {
    return Intl.message('Café', name: 'cafe', desc: '', args: []);
  }

  /// `Exceptional Eats`
  String get exceptional_eats {
    return Intl.message(
      'Exceptional Eats',
      name: 'exceptional_eats',
      desc: '',
      args: [],
    );
  }

  /// `Art`
  String get art {
    return Intl.message('Art', name: 'art', desc: '', args: []);
  }

  /// `TYPE LOCATION HERE`
  String get type_location_here {
    return Intl.message(
      'TYPE LOCATION HERE',
      name: 'type_location_here',
      desc: '',
      args: [],
    );
  }

  /// `Must-See Attractions`
  String get must_see_attractions {
    return Intl.message(
      'Must-See Attractions',
      name: 'must_see_attractions',
      desc: '',
      args: [],
    );
  }

  /// `Ask EVA...`
  String get ask_eva {
    return Intl.message('Ask EVA...', name: 'ask_eva', desc: '', args: []);
  }

  /// `My\nTicket`
  String get my_ticket {
    return Intl.message('My\nTicket', name: 'my_ticket', desc: '', args: []);
  }

  /// `Match Day`
  String get match_day {
    return Intl.message('Match Day', name: 'match_day', desc: '', args: []);
  }

  /// `Direct\nFlights`
  String get direct_flights {
    return Intl.message(
      'Direct\nFlights',
      name: 'direct_flights',
      desc: '',
      args: [],
    );
  }

  /// `Live\nMusic`
  String get live_music {
    return Intl.message('Live\nMusic', name: 'live_music', desc: '', args: []);
  }

  /// `Brunch`
  String get brunch {
    return Intl.message('Brunch', name: 'brunch', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `My\nTeam`
  String get my_team {
    return Intl.message('My\nTeam', name: 'my_team', desc: '', args: []);
  }

  /// `Ticket access, directions, and more`
  String get ticket_access {
    return Intl.message(
      'Ticket access, directions, and more',
      name: 'ticket_access',
      desc: '',
      args: [],
    );
  }

  /// `Find hotels with the amenities you want`
  String get find_hotels {
    return Intl.message(
      'Find hotels with the amenities you want',
      name: 'find_hotels',
      desc: '',
      args: [],
    );
  }

  /// `Explore off the beaten path`
  String get explore_off {
    return Intl.message(
      'Explore off the beaten path',
      name: 'explore_off',
      desc: '',
      args: [],
    );
  }

  /// `Dining experiences you'll love`
  String get dining_experience {
    return Intl.message(
      'Dining experiences you\'ll love',
      name: 'dining_experience',
      desc: '',
      args: [],
    );
  }

  /// `Highlights you don't want to miss`
  String get highlights_you {
    return Intl.message(
      'Highlights you don\'t want to miss',
      name: 'highlights_you',
      desc: '',
      args: [],
    );
  }

  /// `Keep customizing your trip`
  String get keep_customizing {
    return Intl.message(
      'Keep customizing your trip',
      name: 'keep_customizing',
      desc: '',
      args: [],
    );
  }

  /// `Walking\nDistance\nfrom the\nMatch`
  String get walking_distance_from_the_match {
    return Intl.message(
      'Walking\nDistance\nfrom the\nMatch',
      name: 'walking_distance_from_the_match',
      desc: '',
      args: [],
    );
  }

  /// `Hiking`
  String get hiking {
    return Intl.message('Hiking', name: 'hiking', desc: '', args: []);
  }

  /// `Award\nWinning\nFood`
  String get award_winning_food {
    return Intl.message(
      'Award\nWinning\nFood',
      name: 'award_winning_food',
      desc: '',
      args: [],
    );
  }

  /// `Landmarks`
  String get landmarks {
    return Intl.message('Landmarks', name: 'landmarks', desc: '', args: []);
  }

  /// `Personal Preferences`
  String get personal_preferences {
    return Intl.message(
      'Personal Preferences',
      name: 'personal_preferences',
      desc: '',
      args: [],
    );
  }

  /// `Keep customizing your trip. Select all options that interest you.`
  String get keep_customizing_your_trip {
    return Intl.message(
      'Keep customizing your trip. Select all options that interest you.',
      name: 'keep_customizing_your_trip',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Slightly excited`
  String get slightly_excited {
    return Intl.message(
      'Slightly excited',
      name: 'slightly_excited',
      desc: '',
      args: [],
    );
  }

  /// `Looking forward to it`
  String get looking_forward_to_it {
    return Intl.message(
      'Looking forward to it',
      name: 'looking_forward_to_it',
      desc: '',
      args: [],
    );
  }

  /// `Pretty pumped!`
  String get pretty_pumped {
    return Intl.message(
      'Pretty pumped!',
      name: 'pretty_pumped',
      desc: '',
      args: [],
    );
  }

  /// `Super excited!`
  String get super_excited {
    return Intl.message(
      'Super excited!',
      name: 'super_excited',
      desc: '',
      args: [],
    );
  }

  /// `Completely thrilled!`
  String get completely_thrilled {
    return Intl.message(
      'Completely thrilled!',
      name: 'completely_thrilled',
      desc: '',
      args: [],
    );
  }

  /// `I can't wait!`
  String get i_cant_wait {
    return Intl.message(
      'I can\'t wait!',
      name: 'i_cant_wait',
      desc: '',
      args: [],
    );
  }

  /// `Absolutely ecstatic!`
  String get absolutely_ecstatic {
    return Intl.message(
      'Absolutely ecstatic!',
      name: 'absolutely_ecstatic',
      desc: '',
      args: [],
    );
  }

  /// `It's all I've been thinking about!`
  String get its_all_ive_been_thinking_about {
    return Intl.message(
      'It\'s all I\'ve been thinking about!',
      name: 'its_all_ive_been_thinking_about',
      desc: '',
      args: [],
    );
  }

  /// `What hotel features are you looking for?`
  String get app_preferences_questions_hotel_features {
    return Intl.message(
      'What hotel features are you looking for?',
      name: 'app_preferences_questions_hotel_features',
      desc: '',
      args: [],
    );
  }

  /// `Near the stadium`
  String get near_stadium {
    return Intl.message(
      'Near the stadium',
      name: 'near_stadium',
      desc: '',
      args: [],
    );
  }

  /// `Downtown`
  String get downtown {
    return Intl.message('Downtown', name: 'downtown', desc: '', args: []);
  }

  /// `Off the beaten path`
  String get off_the_beaten_path {
    return Intl.message(
      'Off the beaten path',
      name: 'off_the_beaten_path',
      desc: '',
      args: [],
    );
  }

  /// `Pool`
  String get pool {
    return Intl.message('Pool', name: 'pool', desc: '', args: []);
  }

  /// `Restaurant on the property`
  String get restaurant_on_the_property {
    return Intl.message(
      'Restaurant on the property',
      name: 'restaurant_on_the_property',
      desc: '',
      args: [],
    );
  }

  /// `Fitness center`
  String get fitness_center {
    return Intl.message(
      'Fitness center',
      name: 'fitness_center',
      desc: '',
      args: [],
    );
  }

  /// `No preference`
  String get no_preference {
    return Intl.message(
      'No preference',
      name: 'no_preference',
      desc: '',
      args: [],
    );
  }

  /// `What kinds of places do you want to explore?`
  String get app_preferences_questions_attractions_interest {
    return Intl.message(
      'What kinds of places do you want to explore?',
      name: 'app_preferences_questions_attractions_interest',
      desc: '',
      args: [],
    );
  }

  /// `Historic landmarks`
  String get historic_landmarks {
    return Intl.message(
      'Historic landmarks',
      name: 'historic_landmarks',
      desc: '',
      args: [],
    );
  }

  /// `Scenic nature spots`
  String get scenic_nature_spots {
    return Intl.message(
      'Scenic nature spots',
      name: 'scenic_nature_spots',
      desc: '',
      args: [],
    );
  }

  /// `Popular social media photo-opps`
  String get popular_social_media_photo_opps {
    return Intl.message(
      'Popular social media photo-opps',
      name: 'popular_social_media_photo_opps',
      desc: '',
      args: [],
    );
  }

  /// `Adventure experiences`
  String get adventure_experiences {
    return Intl.message(
      'Adventure experiences',
      name: 'adventure_experiences',
      desc: '',
      args: [],
    );
  }

  /// `Local neighborhoods`
  String get local_neighborhoods {
    return Intl.message(
      'Local neighborhoods',
      name: 'local_neighborhoods',
      desc: '',
      args: [],
    );
  }

  /// `Shopping districts`
  String get shopping_districts {
    return Intl.message(
      'Shopping districts',
      name: 'shopping_districts',
      desc: '',
      args: [],
    );
  }

  /// `What kind of dining experiences sound good?`
  String get app_preferences_questions_favoriteCuisine {
    return Intl.message(
      'What kind of dining experiences sound good?',
      name: 'app_preferences_questions_favoriteCuisine',
      desc: '',
      args: [],
    );
  }

  /// `Fine dining`
  String get fine_dining {
    return Intl.message('Fine dining', name: 'fine_dining', desc: '', args: []);
  }

  /// `Casual restaurants`
  String get casual_restaurants {
    return Intl.message(
      'Casual restaurants',
      name: 'casual_restaurants',
      desc: '',
      args: [],
    );
  }

  /// `Street food`
  String get street_food {
    return Intl.message('Street food', name: 'street_food', desc: '', args: []);
  }

  /// `Cafes`
  String get cafes {
    return Intl.message('Cafes', name: 'cafes', desc: '', args: []);
  }

  /// `Food tours`
  String get food_tours {
    return Intl.message('Food tours', name: 'food_tours', desc: '', args: []);
  }

  /// `Choose attractions that interest you.`
  String get app_preferences_questions_places_to_visit {
    return Intl.message(
      'Choose attractions that interest you.',
      name: 'app_preferences_questions_places_to_visit',
      desc: '',
      args: [],
    );
  }

  /// `Museums`
  String get museums {
    return Intl.message('Museums', name: 'museums', desc: '', args: []);
  }

  /// `Parks And Gardens`
  String get parks_and_gardens {
    return Intl.message(
      'Parks And Gardens',
      name: 'parks_and_gardens',
      desc: '',
      args: [],
    );
  }

  /// `Historical Landmarks`
  String get historical_landmarks {
    return Intl.message(
      'Historical Landmarks',
      name: 'historical_landmarks',
      desc: '',
      args: [],
    );
  }

  /// `Theme Parks`
  String get theme_parks {
    return Intl.message('Theme Parks', name: 'theme_parks', desc: '', args: []);
  }

  /// `Shopping Centers`
  String get shopping_centers {
    return Intl.message(
      'Shopping Centers',
      name: 'shopping_centers',
      desc: '',
      args: [],
    );
  }

  /// `Nightlife`
  String get nightlife {
    return Intl.message('Nightlife', name: 'nightlife', desc: '', args: []);
  }

  /// `Family-friendly fun`
  String get family_friendly_fun {
    return Intl.message(
      'Family-friendly fun',
      name: 'family_friendly_fun',
      desc: '',
      args: [],
    );
  }

  /// `Check to ensure you are using the email address associated with your invitation.`
  String get user_does_not_exist {
    return Intl.message(
      'Check to ensure you are using the email address associated with your invitation.',
      name: 'user_does_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect email or password. Please try again or reset password.`
  String get incorrect_username {
    return Intl.message(
      'Incorrect email or password. Please try again or reset password.',
      name: 'incorrect_username',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Try again later.`
  String get too_many_attempts {
    return Intl.message(
      'Too many attempts. Try again later.',
      name: 'too_many_attempts',
      desc: '',
      args: [],
    );
  }

  /// `You must verify your account. Please check your email or resend code.`
  String get account_not_verify {
    return Intl.message(
      'You must verify your account. Please check your email or resend code.',
      name: 'account_not_verify',
      desc: '',
      args: [],
    );
  }

  /// `Your account is not active. Please reach out to [VISA support contact TBD].`
  String get user_is_disable {
    return Intl.message(
      'Your account is not active. Please reach out to [VISA support contact TBD].',
      name: 'user_is_disable',
      desc: '',
      args: [],
    );
  }

  /// `Password reset is required. Please click 'Forgot Password' to continue.`
  String get password_reset_required {
    return Intl.message(
      'Password reset is required. Please click \'Forgot Password\' to continue.',
      name: 'password_reset_required',
      desc: '',
      args: [],
    );
  }

  /// `Orchestrate Authentication Failed`
  String get orchestrate_authentication_failed {
    return Intl.message(
      'Orchestrate Authentication Failed',
      name: 'orchestrate_authentication_failed',
      desc: '',
      args: [],
    );
  }

  /// `Algeria`
  String get algeria {
    return Intl.message('Algeria', name: 'algeria', desc: '', args: []);
  }

  /// `Argentina`
  String get argentina {
    return Intl.message('Argentina', name: 'argentina', desc: '', args: []);
  }

  /// `Australia`
  String get australia {
    return Intl.message('Australia', name: 'australia', desc: '', args: []);
  }

  /// `Belgium`
  String get belgium {
    return Intl.message('Belgium', name: 'belgium', desc: '', args: []);
  }

  /// `Brazil`
  String get brazil {
    return Intl.message('Brazil', name: 'brazil', desc: '', args: []);
  }

  /// `Cameroon`
  String get cameroon {
    return Intl.message('Cameroon', name: 'cameroon', desc: '', args: []);
  }

  /// `Canada`
  String get canada {
    return Intl.message('Canada', name: 'canada', desc: '', args: []);
  }

  /// `Chile`
  String get chile {
    return Intl.message('Chile', name: 'chile', desc: '', args: []);
  }

  /// `Colombia`
  String get colombia {
    return Intl.message('Colombia', name: 'colombia', desc: '', args: []);
  }

  /// `Costa Rica`
  String get costa_rica {
    return Intl.message('Costa Rica', name: 'costa_rica', desc: '', args: []);
  }

  /// `Croatia`
  String get croatia {
    return Intl.message('Croatia', name: 'croatia', desc: '', args: []);
  }

  /// `Denmark`
  String get denmark {
    return Intl.message('Denmark', name: 'denmark', desc: '', args: []);
  }

  /// `DR Congo`
  String get dr_congo {
    return Intl.message('DR Congo', name: 'dr_congo', desc: '', args: []);
  }

  /// `Ecuador`
  String get ecuador {
    return Intl.message('Ecuador', name: 'ecuador', desc: '', args: []);
  }

  /// `Egypt`
  String get egypt {
    return Intl.message('Egypt', name: 'egypt', desc: '', args: []);
  }

  /// `England`
  String get england {
    return Intl.message('England', name: 'england', desc: '', args: []);
  }

  /// `France`
  String get france {
    return Intl.message('France', name: 'france', desc: '', args: []);
  }

  /// `Germany`
  String get germany {
    return Intl.message('Germany', name: 'germany', desc: '', args: []);
  }

  /// `Ghana`
  String get ghana {
    return Intl.message('Ghana', name: 'ghana', desc: '', args: []);
  }

  /// `Iran`
  String get iran {
    return Intl.message('Iran', name: 'iran', desc: '', args: []);
  }

  /// `Iraq`
  String get iraq {
    return Intl.message('Iraq', name: 'iraq', desc: '', args: []);
  }

  /// `Jamaica`
  String get jamaica {
    return Intl.message('Jamaica', name: 'jamaica', desc: '', args: []);
  }

  /// `Japan`
  String get japan {
    return Intl.message('Japan', name: 'japan', desc: '', args: []);
  }

  /// `Mali`
  String get mali {
    return Intl.message('Mali', name: 'mali', desc: '', args: []);
  }

  /// `Mexico`
  String get mexico {
    return Intl.message('Mexico', name: 'mexico', desc: '', args: []);
  }

  /// `Morocco`
  String get morocco {
    return Intl.message('Morocco', name: 'morocco', desc: '', args: []);
  }

  /// `Netherlands`
  String get netherlands {
    return Intl.message('Netherlands', name: 'netherlands', desc: '', args: []);
  }

  /// `New Zealand`
  String get new_zealand {
    return Intl.message('New Zealand', name: 'new_zealand', desc: '', args: []);
  }

  /// `Nigeria`
  String get nigeria {
    return Intl.message('Nigeria', name: 'nigeria', desc: '', args: []);
  }

  /// `North Macedonia`
  String get north_mocedania {
    return Intl.message(
      'North Macedonia',
      name: 'north_mocedania',
      desc: '',
      args: [],
    );
  }

  /// `Panama`
  String get panama {
    return Intl.message('Panama', name: 'panama', desc: '', args: []);
  }

  /// `Peru`
  String get peru {
    return Intl.message('Peru', name: 'peru', desc: '', args: []);
  }

  /// `Poland`
  String get poland {
    return Intl.message('Poland', name: 'poland', desc: '', args: []);
  }

  /// `Portugal`
  String get portugal {
    return Intl.message('Portugal', name: 'portugal', desc: '', args: []);
  }

  /// `Qatar`
  String get qatar {
    return Intl.message('Qatar', name: 'qatar', desc: '', args: []);
  }

  /// `Saudi Arabia`
  String get saudi_arabia {
    return Intl.message(
      'Saudi Arabia',
      name: 'saudi_arabia',
      desc: '',
      args: [],
    );
  }

  /// `Senegal`
  String get senegal {
    return Intl.message('Senegal', name: 'senegal', desc: '', args: []);
  }

  /// `Serbia`
  String get serbia {
    return Intl.message('Serbia', name: 'serbia', desc: '', args: []);
  }

  /// `South Korea`
  String get south_korea {
    return Intl.message('South Korea', name: 'south_korea', desc: '', args: []);
  }

  /// `North Macedonia`
  String get north_macedonia {
    return Intl.message(
      'North Macedonia',
      name: 'north_macedonia',
      desc: '',
      args: [],
    );
  }

  /// `Spain`
  String get spain {
    return Intl.message('Spain', name: 'spain', desc: '', args: []);
  }

  /// `Sweden`
  String get sweden {
    return Intl.message('Sweden', name: 'sweden', desc: '', args: []);
  }

  /// `Switzerland`
  String get switzerland {
    return Intl.message('Switzerland', name: 'switzerland', desc: '', args: []);
  }

  /// `Tunisia`
  String get tunisia {
    return Intl.message('Tunisia', name: 'tunisia', desc: '', args: []);
  }

  /// `UAE`
  String get uae {
    return Intl.message('UAE', name: 'uae', desc: '', args: []);
  }

  /// `Ukraine`
  String get ukraine {
    return Intl.message('Ukraine', name: 'ukraine', desc: '', args: []);
  }

  /// `Uruguay`
  String get uruguay {
    return Intl.message('Uruguay', name: 'uruguay', desc: '', args: []);
  }

  /// `USA`
  String get usa {
    return Intl.message('USA', name: 'usa', desc: '', args: []);
  }

  /// `Wales`
  String get wales {
    return Intl.message('Wales', name: 'wales', desc: '', args: []);
  }

  /// `Worldwide Partner`
  String get worldwide_partner {
    return Intl.message(
      'Worldwide Partner',
      name: 'worldwide_partner',
      desc: '',
      args: [],
    );
  }

  /// `Ticket Details`
  String get ticket_details {
    return Intl.message(
      'Ticket Details',
      name: 'ticket_details',
      desc: '',
      args: [],
    );
  }

  /// `Admin has reset your password. Use 'Forgot Password' to set a new one.`
  String get user_resetPassword {
    return Intl.message(
      'Admin has reset your password. Use \'Forgot Password\' to set a new one.',
      name: 'user_resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `M14 Argentina vs Germany Seattle, WA, USA`
  String get ticket_address {
    return Intl.message(
      'M14 Argentina vs Germany Seattle, WA, USA',
      name: 'ticket_address',
      desc: '',
      args: [],
    );
  }

  /// `Select all that interest you or type something in the chat bar.`
  String get select_interest_message {
    return Intl.message(
      'Select all that interest you or type something in the chat bar.',
      name: 'select_interest_message',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get response. Please try again.`
  String get failed_response {
    return Intl.message(
      'Failed to get response. Please try again.',
      name: 'failed_response',
      desc: '',
      args: [],
    );
  }

  /// `Null AI response`
  String get null_ai_response {
    return Intl.message(
      'Null AI response',
      name: 'null_ai_response',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please Check VPN Profile`
  String get something_went_wrong_vpn_issue {
    return Intl.message(
      'Something went wrong. Please Check VPN Profile',
      name: 'something_went_wrong_vpn_issue',
      desc: '',
      args: [],
    );
  }

  /// `Conversation History`
  String get conversation_history {
    return Intl.message(
      'Conversation History',
      name: 'conversation_history',
      desc: '',
      args: [],
    );
  }

  /// `Select a conversation to revisit or Manage History`
  String get select_conversation {
    return Intl.message(
      'Select a conversation to revisit or Manage History',
      name: 'select_conversation',
      desc: '',
      args: [],
    );
  }

  /// `Manage History`
  String get manage_history {
    return Intl.message(
      'Manage History',
      name: 'manage_history',
      desc: '',
      args: [],
    );
  }

  /// `Select conversation(s) to delete.`
  String get select_conversation_delete {
    return Intl.message(
      'Select conversation(s) to delete.',
      name: 'select_conversation_delete',
      desc: '',
      args: [],
    );
  }

  /// `inactive logout`
  String get inactive_logout {
    return Intl.message(
      'inactive logout',
      name: 'inactive_logout',
      desc: '',
      args: [],
    );
  }

  /// `EVA Conversation History`
  String get eva_history {
    return Intl.message(
      'EVA Conversation History',
      name: 'eva_history',
      desc: '',
      args: [],
    );
  }

  /// `Create Password`
  String get create_password {
    return Intl.message(
      'Create Password',
      name: 'create_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Start New chat`
  String get start_new_chat {
    return Intl.message(
      'Start New chat',
      name: 'start_new_chat',
      desc: '',
      args: [],
    );
  }

  /// `Rate EVA's Response`
  String get rate_eva_response {
    return Intl.message(
      'Rate EVA\'s Response',
      name: 'rate_eva_response',
      desc: '',
      args: [],
    );
  }

  /// `L:`
  String get low {
    return Intl.message('L:', name: 'low', desc: '', args: []);
  }

  /// `H:`
  String get high {
    return Intl.message('H:', name: 'high', desc: '', args: []);
  }

  /// `°F`
  String get fahrenheit {
    return Intl.message('°F', name: 'fahrenheit', desc: '', args: []);
  }

  /// `°C`
  String get celsius {
    return Intl.message('°C', name: 'celsius', desc: '', args: []);
  }

  /// `Invalid Date`
  String get invalid_date {
    return Intl.message(
      'Invalid Date',
      name: 'invalid_date',
      desc: '',
      args: [],
    );
  }

  /// `Match City`
  String get match_city {
    return Intl.message('Match City', name: 'match_city', desc: '', args: []);
  }

  /// `FAQ`
  String get faq {
    return Intl.message('FAQ', name: 'faq', desc: '', args: []);
  }

  /// `Privacy Notice`
  String get privacy_notice {
    return Intl.message(
      'Privacy Notice',
      name: 'privacy_notice',
      desc: '',
      args: [],
    );
  }

  /// `Open in Maps`
  String get open_in_maps {
    return Intl.message(
      'Open in Maps',
      name: 'open_in_maps',
      desc: '',
      args: [],
    );
  }

  /// `Add to Itinerary`
  String get add_to_itinerary {
    return Intl.message(
      'Add to Itinerary',
      name: 'add_to_itinerary',
      desc: '',
      args: [],
    );
  }

  /// `Open Now`
  String get open_now {
    return Intl.message('Open Now', name: 'open_now', desc: '', args: []);
  }

  /// `Closed`
  String get closed {
    return Intl.message('Closed', name: 'closed', desc: '', args: []);
  }

  /// `Could not launch`
  String get could_not_launch {
    return Intl.message(
      'Could not launch',
      name: 'could_not_launch',
      desc: '',
      args: [],
    );
  }

  /// `To use Face ID, please enable biometric access in your iPhone settings`
  String get user_decline_biometrics {
    return Intl.message(
      'To use Face ID, please enable biometric access in your iPhone settings',
      name: 'user_decline_biometrics',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Face ID`
  String get face_id {
    return Intl.message('Face ID', name: 'face_id', desc: '', args: []);
  }

  /// `Source`
  String get source {
    return Intl.message('Source', name: 'source', desc: '', args: []);
  }

  /// `Analyzing...`
  String get analyzing {
    return Intl.message('Analyzing...', name: 'analyzing', desc: '', args: []);
  }

  /// `Fetching data...`
  String get fetching_data {
    return Intl.message(
      'Fetching data...',
      name: 'fetching_data',
      desc: '',
      args: [],
    );
  }

  /// `Processing...`
  String get processing {
    return Intl.message(
      'Processing...',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Invalid current password`
  String get invalid_current_password {
    return Intl.message(
      'Invalid current password',
      name: 'invalid_current_password',
      desc: '',
      args: [],
    );
  }

  /// `Invalid confirm password`
  String get invalid_confirm_password {
    return Intl.message(
      'Invalid confirm password',
      name: 'invalid_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Open Setting`
  String get open_setting {
    return Intl.message(
      'Open Setting',
      name: 'open_setting',
      desc: '',
      args: [],
    );
  }

  /// `Invalid new password`
  String get invalid_new_password {
    return Intl.message(
      'Invalid new password',
      name: 'invalid_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must be the same as the new password`
  String get invalid_cnf_new_pass {
    return Intl.message(
      'Confirm password must be the same as the new password',
      name: 'invalid_cnf_new_pass',
      desc: '',
      args: [],
    );
  }

  /// `MFA enabled successfully.`
  String get mfa_enable_success {
    return Intl.message(
      'MFA enabled successfully.',
      name: 'mfa_enable_success',
      desc: '',
      args: [],
    );
  }

  /// `MFA disabled successfully.`
  String get mfa_disable_success {
    return Intl.message(
      'MFA disabled successfully.',
      name: 'mfa_disable_success',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication enabled successfully.`
  String get biometric_enable_success {
    return Intl.message(
      'Biometric authentication enabled successfully.',
      name: 'biometric_enable_success',
      desc: '',
      args: [],
    );
  }

  /// `Biometrics has been turned off.`
  String get biometric_disable_success {
    return Intl.message(
      'Biometrics has been turned off.',
      name: 'biometric_disable_success',
      desc: '',
      args: [],
    );
  }

  /// `Notifications enabled successfully.`
  String get notifications_enable_success {
    return Intl.message(
      'Notifications enabled successfully.',
      name: 'notifications_enable_success',
      desc: '',
      args: [],
    );
  }

  /// `Notifications disabled successfully.`
  String get notifications_disable_success {
    return Intl.message(
      'Notifications disabled successfully.',
      name: 'notifications_disable_success',
      desc: '',
      args: [],
    );
  }

  /// `Failed to enable MFA. Please try again.`
  String get mfa_enable_error {
    return Intl.message(
      'Failed to enable MFA. Please try again.',
      name: 'mfa_enable_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to disable MFA. Please try again.`
  String get mfa_disable_error {
    return Intl.message(
      'Failed to disable MFA. Please try again.',
      name: 'mfa_disable_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to enable biometric authentication. Please try again.`
  String get biometric_enable_error {
    return Intl.message(
      'Failed to enable biometric authentication. Please try again.',
      name: 'biometric_enable_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to disable biometric authentication. Please try again.`
  String get biometric_disable_error {
    return Intl.message(
      'Failed to disable biometric authentication. Please try again.',
      name: 'biometric_disable_error',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication is not supported on this device.`
  String get biometric_not_supported {
    return Intl.message(
      'Biometric authentication is not supported on this device.',
      name: 'biometric_not_supported',
      desc: '',
      args: [],
    );
  }

  /// `Failed to enable notifications. Please try again.`
  String get notifications_enable_error {
    return Intl.message(
      'Failed to enable notifications. Please try again.',
      name: 'notifications_enable_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to disable notifications. Please try again.`
  String get notifications_disable_error {
    return Intl.message(
      'Failed to disable notifications. Please try again.',
      name: 'notifications_disable_error',
      desc: '',
      args: [],
    );
  }

  /// `Current password is required`
  String get current_password_is_required {
    return Intl.message(
      'Current password is required',
      name: 'current_password_is_required',
      desc: '',
      args: [],
    );
  }

  /// `New password is required`
  String get new_password_is_required {
    return Intl.message(
      'New password is required',
      name: 'new_password_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been updated successfully`
  String get password_change_success {
    return Intl.message(
      'Your password has been updated successfully',
      name: 'password_change_success',
      desc: '',
      args: [],
    );
  }

  /// `Language changed successfully.`
  String get language_change_success {
    return Intl.message(
      'Language changed successfully.',
      name: 'language_change_success',
      desc: '',
      args: [],
    );
  }

  /// `You're all caught up. New notifications will appear here.`
  String get no_notification {
    return Intl.message(
      'You\'re all caught up. New notifications will appear here.',
      name: 'no_notification',
      desc: '',
      args: [],
    );
  }

  /// `To use biometrics, please allow biometric access in your phone settings.`
  String get user_decline_biometrics_android {
    return Intl.message(
      'To use biometrics, please allow biometric access in your phone settings.',
      name: 'user_decline_biometrics_android',
      desc: '',
      args: [],
    );
  }

  /// `There was a problem processing your request. Please retry.`
  String get problem_processing {
    return Intl.message(
      'There was a problem processing your request. Please retry.',
      name: 'problem_processing',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Deleting your account will remove all of your saved data.`
  String get deleting_your_account {
    return Intl.message(
      'Deleting your account will remove all of your saved data.',
      name: 'deleting_your_account',
      desc: '',
      args: [],
    );
  }

  /// `What about my Tickets?`
  String get what_about_my_tickets {
    return Intl.message(
      'What about my Tickets?',
      name: 'what_about_my_tickets',
      desc: '',
      args: [],
    );
  }

  /// `Your FIFA World Cup™ tickets are still yours! To access your tickets,`
  String get your_fifa_word_cup_tickets_still_yours {
    return Intl.message(
      'Your FIFA World Cup™ tickets are still yours! To access your tickets,',
      name: 'your_fifa_word_cup_tickets_still_yours',
      desc: '',
      args: [],
    );
  }

  /// `you MUST register in the FIFA app`
  String get you_must_register {
    return Intl.message(
      'you MUST register in the FIFA app',
      name: 'you_must_register',
      desc: '',
      args: [],
    );
  }

  /// `with the same email you used for Visa Go. Tickets are released 3 days before the Match. If you don't see your tickets in the FIFA app 48 hours before the Match, please contact our`
  String get with_the_same_email {
    return Intl.message(
      'with the same email you used for Visa Go. Tickets are released 3 days before the Match. If you don\'t see your tickets in the FIFA app 48 hours before the Match, please contact our',
      name: 'with_the_same_email',
      desc: '',
      args: [],
    );
  }

  /// `Ticketing Team.`
  String get ticketing_team {
    return Intl.message(
      'Ticketing Team.',
      name: 'ticketing_team',
      desc: '',
      args: [],
    );
  }

  /// `Before you delete, consider these options:`
  String get before_you_delete {
    return Intl.message(
      'Before you delete, consider these options:',
      name: 'before_you_delete',
      desc: '',
      args: [],
    );
  }

  /// `Disable push notifications from your`
  String get disable_push_notification {
    return Intl.message(
      'Disable push notifications from your',
      name: 'disable_push_notification',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile_text {
    return Intl.message('Profile', name: 'profile_text', desc: '', args: []);
  }

  /// `Review our`
  String get review_our {
    return Intl.message('Review our', name: 'review_our', desc: '', args: []);
  }

  /// `FAQ Page`
  String get faq_page {
    return Intl.message('FAQ Page', name: 'faq_page', desc: '', args: []);
  }

  /// `Anything else?`
  String get anything_else {
    return Intl.message(
      'Anything else?',
      name: 'anything_else',
      desc: '',
      args: [],
    );
  }

  /// `Contact Support.`
  String get contact_support {
    return Intl.message(
      'Contact Support.',
      name: 'contact_support',
      desc: '',
      args: [],
    );
  }

  /// `If at any time you would like to come back to the app you will need to create a new account.`
  String get come_back_message {
    return Intl.message(
      'If at any time you would like to come back to the app you will need to create a new account.',
      name: 'come_back_message',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Account Deletion`
  String get confirm_account_deletion {
    return Intl.message(
      'Confirm Account Deletion',
      name: 'confirm_account_deletion',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password to confirm`
  String get enter_password_to_confirm {
    return Intl.message(
      'Please enter your password to confirm',
      name: 'enter_password_to_confirm',
      desc: '',
      args: [],
    );
  }

  /// `PASSWORD*`
  String get password_star {
    return Intl.message('PASSWORD*', name: 'password_star', desc: '', args: []);
  }

  /// `Enter your password`
  String get enter_your_password {
    return Intl.message(
      'Enter your password',
      name: 'enter_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been deleted.`
  String get your_account_has_been_deleted {
    return Intl.message(
      'Your account has been deleted.',
      name: 'your_account_has_been_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Delete your account?`
  String get delete_your_account {
    return Intl.message(
      'Delete your account?',
      name: 'delete_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Unknown authentication error.`
  String get unknown_authentication_error {
    return Intl.message(
      'Unknown authentication error.',
      name: 'unknown_authentication_error',
      desc: '',
      args: [],
    );
  }

  /// `User not found.`
  String get user_not_found {
    return Intl.message(
      'User not found.',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `User is not confirmed.`
  String get user_is_not_confirmed {
    return Intl.message(
      'User is not confirmed.',
      name: 'user_is_not_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to Booking.com.`
  String get you_are_being_redirect_booking {
    return Intl.message(
      'You are being redirected to Booking.com.',
      name: 'you_are_being_redirect_booking',
      desc: '',
      args: [],
    );
  }

  /// `Button`
  String get button {
    return Intl.message('Button', name: 'button', desc: '', args: []);
  }

  /// `Please enable notifications from Settings to receive updates.`
  String get enable_push_notiifcation {
    return Intl.message(
      'Please enable notifications from Settings to receive updates.',
      name: 'enable_push_notiifcation',
      desc: '',
      args: [],
    );
  }

  /// `FIFA World Cup 26™`
  String get fifa_word_cup_26 {
    return Intl.message(
      'FIFA World Cup 26™',
      name: 'fifa_word_cup_26',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `HRS`
  String get hrs {
    return Intl.message('HRS', name: 'hrs', desc: '', args: []);
  }

  /// `MINS`
  String get mins {
    return Intl.message('MINS', name: 'mins', desc: '', args: []);
  }

  /// `Tickets are released 3 days\nbefore each Match.`
  String get ticket_released_days {
    return Intl.message(
      'Tickets are released 3 days\nbefore each Match.',
      name: 'ticket_released_days',
      desc: '',
      args: [],
    );
  }

  /// `You will be notified when your tickets\nare available in the FIFA app.`
  String get ticket_notify_when_available {
    return Intl.message(
      'You will be notified when your tickets\nare available in the FIFA app.',
      name: 'ticket_notify_when_available',
      desc: '',
      args: [],
    );
  }

  /// `You have tickets ready!`
  String get ticket_ready {
    return Intl.message(
      'You have tickets ready!',
      name: 'ticket_ready',
      desc: '',
      args: [],
    );
  }

  /// `Get Tickets In FIFA App`
  String get ticket_get_fifa_app {
    return Intl.message(
      'Get Tickets In FIFA App',
      name: 'ticket_get_fifa_app',
      desc: '',
      args: [],
    );
  }

  /// `Ticket Status`
  String get ticket_status {
    return Intl.message(
      'Ticket Status',
      name: 'ticket_status',
      desc: '',
      args: [],
    );
  }

  /// `has officially begun!`
  String get match_officially_begun {
    return Intl.message(
      'has officially begun!',
      name: 'match_officially_begun',
      desc: '',
      args: [],
    );
  }

  /// `THANK YOU FOR JOINING US!`
  String get match_thanks_joining {
    return Intl.message(
      'THANK YOU FOR JOINING US!',
      name: 'match_thanks_joining',
      desc: '',
      args: [],
    );
  }

  /// `Tickets`
  String get match_ticket {
    return Intl.message('Tickets', name: 'match_ticket', desc: '', args: []);
  }

  /// `You are\nnow leaving\nVisa Go`
  String get you_are_now_leaving_visa_go {
    return Intl.message(
      'You are\nnow leaving\nVisa Go',
      name: 'you_are_now_leaving_visa_go',
      desc: '',
      args: [],
    );
  }

  /// `Disable`
  String get disable {
    return Intl.message('Disable', name: 'disable', desc: '', args: []);
  }

  /// `*Required field`
  String get required_field {
    return Intl.message(
      '*Required field',
      name: 'required_field',
      desc: '',
      args: [],
    );
  }

  /// `is required`
  String get is_required {
    return Intl.message('is required', name: 'is_required', desc: '', args: []);
  }

  /// `hide password. button. double tap to activate.`
  String get enable_to_view_password {
    return Intl.message(
      'hide password. button. double tap to activate.',
      name: 'enable_to_view_password',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Oops`
  String get oops {
    return Intl.message('Oops', name: 'oops', desc: '', args: []);
  }

  /// `No Internet`
  String get no_internet_connect {
    return Intl.message(
      'No Internet',
      name: 'no_internet_connect',
      desc: '',
      args: [],
    );
  }

  /// `Please check your connection.`
  String get check_connection {
    return Intl.message(
      'Please check your connection.',
      name: 'check_connection',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get try_again_only {
    return Intl.message(
      'Try Again',
      name: 'try_again_only',
      desc: '',
      args: [],
    );
  }

  /// `show password. button. double tap to activate.`
  String get disable_to_hide_password {
    return Intl.message(
      'show password. button. double tap to activate.',
      name: 'disable_to_hide_password',
      desc: '',
      args: [],
    );
  }

  /// `To access your tickets, `
  String get ticket_access_info_1 {
    return Intl.message(
      'To access your tickets, ',
      name: 'ticket_access_info_1',
      desc: '',
      args: [],
    );
  }

  /// `you MUST\nregister in the FIFA app `
  String get ticket_access_info_2 {
    return Intl.message(
      'you MUST\nregister in the FIFA app ',
      name: 'ticket_access_info_2',
      desc: '',
      args: [],
    );
  }

  /// `with the\nsame email you used for this app.`
  String get ticket_access_info_3 {
    return Intl.message(
      'with the\nsame email you used for this app.',
      name: 'ticket_access_info_3',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one {Ticket} other {Tickets}}`
  String ticket_count(int count) {
    return Intl.plural(
      count,
      one: 'Ticket',
      other: 'Tickets',
      name: 'ticket_count',
      desc: 'Pluralized ticket word depending on count',
      args: [count],
    );
  }

  /// `Ask EVA about your\nupcoming Match`
  String get ask_eva_about_upcoming_match {
    return Intl.message(
      'Ask EVA about your\nupcoming Match',
      name: 'ask_eva_about_upcoming_match',
      desc: '',
      args: [],
    );
  }

  /// `Preparing for the Match`
  String get preparing_match_title {
    return Intl.message(
      'Preparing for the Match',
      name: 'preparing_match_title',
      desc: '',
      args: [],
    );
  }

  /// `Arrive early.`
  String get preparing_match_description {
    return Intl.message(
      'Arrive early.',
      name: 'preparing_match_description',
      desc: '',
      args: [],
    );
  }

  /// `Check FIFA's FAQs`
  String get check_fifa_faqs {
    return Intl.message(
      'Check FIFA\'s FAQs',
      name: 'check_fifa_faqs',
      desc: '',
      args: [],
    );
  }

  /// `for restrictions on things such as allowable bags, carry-ins, etc.`
  String get preparing_match_postlink {
    return Intl.message(
      'for restrictions on things such as allowable bags, carry-ins, etc.',
      name: 'preparing_match_postlink',
      desc: '',
      args: [],
    );
  }

  /// `Where are my tickets?`
  String get where_my_ticket_title {
    return Intl.message(
      'Where are my tickets?',
      name: 'where_my_ticket_title',
      desc: '',
      args: [],
    );
  }

  /// `We will notify you when your tickets are available. If you don't see your tickets in the FIFA app 48 hours before the Match, please contact our`
  String get where_my_ticket_description {
    return Intl.message(
      'We will notify you when your tickets are available. If you don\'t see your tickets in the FIFA app 48 hours before the Match, please contact our',
      name: 'where_my_ticket_description',
      desc: '',
      args: [],
    );
  }

  /// `Other ticket questions`
  String get other_ticket_question_title {
    return Intl.message(
      'Other ticket questions',
      name: 'other_ticket_question_title',
      desc: '',
      args: [],
    );
  }

  /// `Check FIFA`
  String get check_fifa {
    return Intl.message('Check FIFA', name: 'check_fifa', desc: '', args: []);
  }

  /// `for the most up-to-date information.`
  String get check_fifa_tail {
    return Intl.message(
      'for the most up-to-date information.',
      name: 'check_fifa_tail',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder_title {
    return Intl.message('Reminder', name: 'reminder_title', desc: '', args: []);
  }

  /// `To access your tickets, you MUST\nregister in the FIFA app using:`
  String get reminder_message {
    return Intl.message(
      'To access your tickets, you MUST\nregister in the FIFA app using:',
      name: 'reminder_message',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `tickets expired`
  String get tickets_expired {
    return Intl.message(
      'tickets expired',
      name: 'tickets_expired',
      desc: '',
      args: [],
    );
  }

  /// `These tickets expired on `
  String get ticket_expired_on {
    return Intl.message(
      'These tickets expired on ',
      name: 'ticket_expired_on',
      desc: '',
      args: [],
    );
  }

  /// `See our `
  String get see_our {
    return Intl.message('See our ', name: 'see_our', desc: '', args: []);
  }

  /// `for more information.`
  String get more_information {
    return Intl.message(
      'for more information.',
      name: 'more_information',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to see here!`
  String get nothing_to_see_here {
    return Intl.message(
      'Nothing to see here!',
      name: 'nothing_to_see_here',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any Matches to view!`
  String get no_match_ticket_message {
    return Intl.message(
      'You don\'t have any Matches to view!',
      name: 'no_match_ticket_message',
      desc: '',
      args: [],
    );
  }

  /// `You have missed the deadline and can no longer attend this match.`
  String get missed_match_ticket {
    return Intl.message(
      'You have missed the deadline and can no longer attend this match.',
      name: 'missed_match_ticket',
      desc: '',
      args: [],
    );
  }

  /// `UTC`
  String get title_utc {
    return Intl.message('UTC', name: 'title_utc', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Tutorial`
  String get tutorial {
    return Intl.message('Tutorial', name: 'tutorial', desc: '', args: []);
  }

  /// `Here's a quick tour to help you get comfortable. In just a few steps, you'll learn how to navigate Visa Go with ease.`
  String get tutorial_quick_tour {
    return Intl.message(
      'Here\'s a quick tour to help you get comfortable. In just a few steps, you\'ll learn how to navigate Visa Go with ease.',
      name: 'tutorial_quick_tour',
      desc: '',
      args: [],
    );
  }

  /// `The one you've been waiting for! Access your tickets and details about your match here.`
  String get ticket_details_info {
    return Intl.message(
      'The one you\'ve been waiting for! Access your tickets and details about your match here.',
      name: 'ticket_details_info',
      desc: '',
      args: [],
    );
  }

  /// `Explore Voyage Access (EVA)\nOur AI-Powered Concierge`
  String get eva_ai_powered_concierge {
    return Intl.message(
      'Explore Voyage Access (EVA)\nOur AI-Powered Concierge',
      name: 'eva_ai_powered_concierge',
      desc: '',
      args: [],
    );
  }

  /// `That's me! Ask me anything about your trip – from restaurants to hidden gems to hotels, I'm here to help you plan an unforgettable experience.`
  String get eva_ai_powered_concierge_info {
    return Intl.message(
      'That\'s me! Ask me anything about your trip – from restaurants to hidden gems to hotels, I\'m here to help you plan an unforgettable experience.',
      name: 'eva_ai_powered_concierge_info',
      desc: '',
      args: [],
    );
  }

  /// `Use your travel credits to help pay for your adventure.`
  String get wallet_info_travel_credit {
    return Intl.message(
      'Use your travel credits to help pay for your adventure.',
      name: 'wallet_info_travel_credit',
      desc: '',
      args: [],
    );
  }

  /// `Use your prepaid card to help pay for your adventure.`
  String get wallet_info_prepaid {
    return Intl.message(
      'Use your prepaid card to help pay for your adventure.',
      name: 'wallet_info_prepaid',
      desc: '',
      args: [],
    );
  }

  /// `Use your travel credits and prepaid card to help pay for your adventure.`
  String get wallet_info_both {
    return Intl.message(
      'Use your travel credits and prepaid card to help pay for your adventure.',
      name: 'wallet_info_both',
      desc: '',
      args: [],
    );
  }

  /// `Prepaid cards are available in Visa Go 1 June through 31 July 2026.`
  String get wallet_sub_info_both {
    return Intl.message(
      'Prepaid cards are available in Visa Go 1 June through 31 July 2026.',
      name: 'wallet_sub_info_both',
      desc: '',
      args: [],
    );
  }

  /// `prepaid card`
  String get prepaid_card {
    return Intl.message(
      'prepaid card',
      name: 'prepaid_card',
      desc: '',
      args: [],
    );
  }

  /// `Plan Your Trip`
  String get plan_your_trip {
    return Intl.message(
      'Plan Your Trip',
      name: 'plan_your_trip',
      desc: '',
      args: [],
    );
  }

  /// `Build out the itinerary of your dreams. Where will you go and who will you share it with? I'm here to help at every step.`
  String get plan_your_trip_info {
    return Intl.message(
      'Build out the itinerary of your dreams. Where will you go and who will you share it with? I\'m here to help at every step.',
      name: 'plan_your_trip_info',
      desc: '',
      args: [],
    );
  }

  /// `Let's get personal!`
  String get lets_get_personal {
    return Intl.message(
      'Let\'s get personal!',
      name: 'lets_get_personal',
      desc: '',
      args: [],
    );
  }

  /// `Tell me about yourself anytime to help inform our conversations.`
  String get lets_get_personal_info {
    return Intl.message(
      'Tell me about yourself anytime to help inform our conversations.',
      name: 'lets_get_personal_info',
      desc: '',
      args: [],
    );
  }

  /// `Got It`
  String get got_it {
    return Intl.message('Got It', name: 'got_it', desc: '', args: []);
  }

  /// `You are being redirected to FIFA.`
  String get you_redirection_fifa {
    return Intl.message(
      'You are being redirected to FIFA.',
      name: 'you_redirection_fifa',
      desc: '',
      args: [],
    );
  }

  /// `Companion invite has been resent.`
  String get companion_invite_has_been_resent {
    return Intl.message(
      'Companion invite has been resent.',
      name: 'companion_invite_has_been_resent',
      desc: '',
      args: [],
    );
  }

  /// `Match is not selected`
  String get match_list_error {
    return Intl.message(
      'Match is not selected',
      name: 'match_list_error',
      desc: '',
      args: [],
    );
  }

  /// `Please acknowledge all required terms before proceeding.`
  String get iAcknowledge_and_iAgree_error {
    return Intl.message(
      'Please acknowledge all required terms before proceeding.',
      name: 'iAcknowledge_and_iAgree_error',
      desc: '',
      args: [],
    );
  }

  /// `Companion Added Successfully`
  String get companion_added {
    return Intl.message(
      'Companion Added Successfully',
      name: 'companion_added',
      desc: '',
      args: [],
    );
  }

  /// `Edit Companion Successfully`
  String get companion_edit_completed {
    return Intl.message(
      'Edit Companion Successfully',
      name: 'companion_edit_completed',
      desc: '',
      args: [],
    );
  }

  /// `Companion Deleted Successfully`
  String get companion_deleted {
    return Intl.message(
      'Companion Deleted Successfully',
      name: 'companion_deleted',
      desc: '',
      args: [],
    );
  }

  /// `primary user cannot be a companion`
  String get primary_user_cannot_be_a_companion {
    return Intl.message(
      'primary user cannot be a companion',
      name: 'primary_user_cannot_be_a_companion',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to Maps`
  String get you_redirection_maps {
    return Intl.message(
      'You are being redirected to Maps',
      name: 'you_redirection_maps',
      desc: '',
      args: [],
    );
  }

  /// `24-hour clock enabled successfully.`
  String get success_24hrs_clock {
    return Intl.message(
      '24-hour clock enabled successfully.',
      name: 'success_24hrs_clock',
      desc: '',
      args: [],
    );
  }

  /// `Time is now shown in 12-hour clock format`
  String get disable_24hrs_clock {
    return Intl.message(
      'Time is now shown in 12-hour clock format',
      name: 'disable_24hrs_clock',
      desc: '',
      args: [],
    );
  }

  /// `Let's Go`
  String get lets_go_button {
    return Intl.message(
      'Let\'s Go',
      name: 'lets_go_button',
      desc: '',
      args: [],
    );
  }

  /// `Add Companion`
  String get add_companion2 {
    return Intl.message(
      'Add Companion',
      name: 'add_companion2',
      desc: '',
      args: [],
    );
  }

  /// `My Companion has given me permission to share their name and email address to obtain Match information within Visa Go.*`
  String get my_companion_has_given {
    return Intl.message(
      'My Companion has given me permission to share their name and email address to obtain Match information within Visa Go.*',
      name: 'my_companion_has_given',
      desc: '',
      args: [],
    );
  }

  /// `Companion email cannot be edited. If you need to update your Companion's email address, first delete this Companion and then add a new Companion.`
  String get companion_email_cannot_be_edited {
    return Intl.message(
      'Companion email cannot be edited. If you need to update your Companion\'s email address, first delete this Companion and then add a new Companion.',
      name: 'companion_email_cannot_be_edited',
      desc: '',
      args: [],
    );
  }

  /// `Please accept the Terms and Conditions to proceed.`
  String get iAcknowledge_not_selected {
    return Intl.message(
      'Please accept the Terms and Conditions to proceed.',
      name: 'iAcknowledge_not_selected',
      desc: '',
      args: [],
    );
  }

  /// `Please accept the Companion Terms and Conditions to proceed`
  String get iAgree_not_selected {
    return Intl.message(
      'Please accept the Companion Terms and Conditions to proceed',
      name: 'iAgree_not_selected',
      desc: '',
      args: [],
    );
  }

  /// `Rate the Visa Go App`
  String get rate_visa_go_app {
    return Intl.message(
      'Rate the Visa Go App',
      name: 'rate_visa_go_app',
      desc: '',
      args: [],
    );
  }

  /// `How are we doing?`
  String get how_are_doing {
    return Intl.message(
      'How are we doing?',
      name: 'how_are_doing',
      desc: '',
      args: [],
    );
  }

  /// `Please select a rating`
  String get please_select_rating {
    return Intl.message(
      'Please select a rating',
      name: 'please_select_rating',
      desc: '',
      args: [],
    );
  }

  /// `Share your thoughts here...`
  String get share_thoughts {
    return Intl.message(
      'Share your thoughts here...',
      name: 'share_thoughts',
      desc: '',
      args: [],
    );
  }

  /// `Tell us more!`
  String get tell_us_more {
    return Intl.message(
      'Tell us more!',
      name: 'tell_us_more',
      desc: '',
      args: [],
    );
  }

  /// `Based on your experience, what would you like others to know? Tell the world in the app store.`
  String get app_store_prompt {
    return Intl.message(
      'Based on your experience, what would you like others to know? Tell the world in the app store.',
      name: 'app_store_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Take Me to the App Store`
  String get take_me_to_app_store {
    return Intl.message(
      'Take Me to the App Store',
      name: 'take_me_to_app_store',
      desc: '',
      args: [],
    );
  }

  /// `Take Me to the Play Store`
  String get take_me_to_play_store {
    return Intl.message(
      'Take Me to the Play Store',
      name: 'take_me_to_play_store',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for your feedback, it helps us improve.`
  String get thanks_feedback {
    return Intl.message(
      'Thanks for your feedback, it helps us improve.',
      name: 'thanks_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Sorry we missed\nthe mark.`
  String get sorry_missed_mark {
    return Intl.message(
      'Sorry we missed\nthe mark.',
      name: 'sorry_missed_mark',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to the App Store.`
  String get redirect_app_store {
    return Intl.message(
      'You are being redirected to the App Store.',
      name: 'redirect_app_store',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to the Play Store.`
  String get redirect_play_store {
    return Intl.message(
      'You are being redirected to the Play Store.',
      name: 'redirect_play_store',
      desc: '',
      args: [],
    );
  }

  /// `See More`
  String get see_more {
    return Intl.message('See More', name: 'see_more', desc: '', args: []);
  }

  /// `Open on Booking.com`
  String get open_on_booking {
    return Intl.message(
      'Open on Booking.com',
      name: 'open_on_booking',
      desc: '',
      args: [],
    );
  }

  /// `reviews`
  String get reviews {
    return Intl.message('reviews', name: 'reviews', desc: '', args: []);
  }

  /// `Prices for`
  String get price_for {
    return Intl.message('Prices for', name: 'price_for', desc: '', args: []);
  }

  /// `adults`
  String get adults {
    return Intl.message('adults', name: 'adults', desc: '', args: []);
  }

  /// `nights`
  String get nights {
    return Intl.message('nights', name: 'nights', desc: '', args: []);
  }

  /// `View and Book Flights`
  String get view_and_book_flights {
    return Intl.message(
      'View and Book Flights',
      name: 'view_and_book_flights',
      desc: '',
      args: [],
    );
  }

  /// `Can I still go the FIFA World Cup 26™?`
  String get can_i_still_go {
    return Intl.message(
      'Can I still go the FIFA World Cup 26™?',
      name: 'can_i_still_go',
      desc: '',
      args: [],
    );
  }

  /// `Yes! You can still go to the Match, either with your host or if your host transfers tickets to you in the FIFA App.`
  String get yes_your_can_still {
    return Intl.message(
      'Yes! You can still go to the Match, either with your host or if your host transfers tickets to you in the FIFA App.',
      name: 'yes_your_can_still',
      desc: '',
      args: [],
    );
  }

  /// `Already Added`
  String get already_added {
    return Intl.message(
      'Already Added',
      name: 'already_added',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete account`
  String get failed_to_delete_account {
    return Intl.message(
      'Failed to delete account',
      name: 'failed_to_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get txt_available {
    return Intl.message('Available', name: 'txt_available', desc: '', args: []);
  }

  /// `PLAYOFFS ARE UNDERWAY!`
  String get playoff_underway {
    return Intl.message(
      'PLAYOFFS ARE UNDERWAY!',
      name: 'playoff_underway',
      desc: '',
      args: [],
    );
  }

  /// `IS IN PROGRESS`
  String get match_is_in_progress {
    return Intl.message(
      'IS IN PROGRESS',
      name: 'match_is_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `is in progress`
  String get ticket_match_progress {
    return Intl.message(
      'is in progress',
      name: 'ticket_match_progress',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logout_confirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logout_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Have you redeemed your travel credit yet?`
  String get have_you_redeemed {
    return Intl.message(
      'Have you redeemed your travel credit yet?',
      name: 'have_you_redeemed',
      desc: '',
      args: [],
    );
  }

  /// `Your session has expired, Please login again`
  String get your_session_has {
    return Intl.message(
      'Your session has expired, Please login again',
      name: 'your_session_has',
      desc: '',
      args: [],
    );
  }

  /// `I confirm that I have read and agree to the `
  String get i_confirm_that {
    return Intl.message(
      'I confirm that I have read and agree to the ',
      name: 'i_confirm_that',
      desc: '',
      args: [],
    );
  }

  /// `I acknowledge that I have read and understood the `
  String get i_acknowledge_that_i {
    return Intl.message(
      'I acknowledge that I have read and understood the ',
      name: 'i_acknowledge_that_i',
      desc: '',
      args: [],
    );
  }

  /// `Please acknowledge all required terms before proceeding.`
  String get please_acknowledge_all {
    return Intl.message(
      'Please acknowledge all required terms before proceeding.',
      name: 'please_acknowledge_all',
      desc: '',
      args: [],
    );
  }

  /// `Your host will be notified and will manage the tickets when they become available. Your host can transfer tickets to you in the FIFA app, but that is optional and only necessary if you plan to enter the Match separately. We encourage you to head to the Match together!`
  String get where_my_ticket_description_companion {
    return Intl.message(
      'Your host will be notified and will manage the tickets when they become available. Your host can transfer tickets to you in the FIFA app, but that is optional and only necessary if you plan to enter the Match separately. We encourage you to head to the Match together!',
      name: 'where_my_ticket_description_companion',
      desc: '',
      args: [],
    );
  }

  /// `Tickets will be available soon.`
  String get ticket_available_soon_companion {
    return Intl.message(
      'Tickets will be available soon.',
      name: 'ticket_available_soon_companion',
      desc: '',
      args: [],
    );
  }

  /// `Your host will be notified when\ntickets are available.`
  String get ticket_notifi_when_available_companion {
    return Intl.message(
      'Your host will be notified when\ntickets are available.',
      name: 'ticket_notifi_when_available_companion',
      desc: '',
      args: [],
    );
  }

  /// `Your host has been notified.\nGet excited for the Match!`
  String get ticket_by_host_avavaible_companion {
    return Intl.message(
      'Your host has been notified.\nGet excited for the Match!',
      name: 'ticket_by_host_avavaible_companion',
      desc: '',
      args: [],
    );
  }

  /// `Tickets are available!`
  String get ticket_available_companion {
    return Intl.message(
      'Tickets are available!',
      name: 'ticket_available_companion',
      desc: '',
      args: [],
    );
  }

  /// `Please select conversation to delete`
  String get conversation_delete_error {
    return Intl.message(
      'Please select conversation to delete',
      name: 'conversation_delete_error',
      desc: '',
      args: [],
    );
  }

  /// `Your code has expired. Please resend code`
  String get otp_expired {
    return Intl.message(
      'Your code has expired. Please resend code',
      name: 'otp_expired',
      desc: '',
      args: [],
    );
  }

  /// `Visa Go`
  String get visa_go {
    return Intl.message('Visa Go', name: 'visa_go', desc: '', args: []);
  }

  /// `Copy URL`
  String get copy_url {
    return Intl.message('Copy URL', name: 'copy_url', desc: '', args: []);
  }

  /// `Open in external browser`
  String get open_in_external_browser {
    return Intl.message(
      'Open in external browser',
      name: 'open_in_external_browser',
      desc: '',
      args: [],
    );
  }

  /// `Events are shown in their local time zones.`
  String get events_local_time_zone {
    return Intl.message(
      'Events are shown in their local time zones.',
      name: 'events_local_time_zone',
      desc: '',
      args: [],
    );
  }

  /// `Book flights, hotels,\ntransportation and more`
  String get book_and_more {
    return Intl.message(
      'Book flights, hotels,\ntransportation and more',
      name: 'book_and_more',
      desc: '',
      args: [],
    );
  }

  /// `Add New Event`
  String get add_new_event {
    return Intl.message(
      'Add New Event',
      name: 'add_new_event',
      desc: '',
      args: [],
    );
  }

  /// `BACK TO TOP`
  String get back_to_top {
    return Intl.message('BACK TO TOP', name: 'back_to_top', desc: '', args: []);
  }

  /// `No events scheduled yet! Book travel or add events to build your itinerary.`
  String get no_event_for_day {
    return Intl.message(
      'No events scheduled yet! Book travel or add events to build your itinerary.',
      name: 'no_event_for_day',
      desc: '',
      args: [],
    );
  }

  /// `More Details`
  String get more_details {
    return Intl.message(
      'More Details',
      name: 'more_details',
      desc: '',
      args: [],
    );
  }

  /// `Event Name`
  String get event_name {
    return Intl.message('Event Name', name: 'event_name', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `End (Optional)`
  String get end_optional {
    return Intl.message(
      'End (Optional)',
      name: 'end_optional',
      desc: '',
      args: [],
    );
  }

  /// `Enter time using the destination's local time.`
  String get enter_time_using {
    return Intl.message(
      'Enter time using the destination\'s local time.',
      name: 'enter_time_using',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `DD/MM/YYYY`
  String get date_format {
    return Intl.message('DD/MM/YYYY', name: 'date_format', desc: '', args: []);
  }

  /// `00:00`
  String get time_default {
    return Intl.message('00:00', name: 'time_default', desc: '', args: []);
  }

  /// `Category*`
  String get category_optional {
    return Intl.message(
      'Category*',
      name: 'category_optional',
      desc: '',
      args: [],
    );
  }

  /// `Description (Optional)`
  String get description_optional {
    return Intl.message(
      'Description (Optional)',
      name: 'description_optional',
      desc: '',
      args: [],
    );
  }

  /// `Adding to your itinerary does not guarantee entry or make a reservation. For locations that require reservations, please contact the location directly.`
  String get adding_to_your_itinerary {
    return Intl.message(
      'Adding to your itinerary does not guarantee entry or make a reservation. For locations that require reservations, please contact the location directly.',
      name: 'adding_to_your_itinerary',
      desc: '',
      args: [],
    );
  }

  /// `Event name is required`
  String get event_name_is_required {
    return Intl.message(
      'Event name is required',
      name: 'event_name_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Event name is invalid`
  String get event_name_is_invalid {
    return Intl.message(
      'Event name is invalid',
      name: 'event_name_is_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Date is required`
  String get date_is_required {
    return Intl.message(
      'Date is required',
      name: 'date_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Date is invalid`
  String get date_is_invalid {
    return Intl.message(
      'Date is invalid',
      name: 'date_is_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Start time is required`
  String get start_time_is_required {
    return Intl.message(
      'Start time is required',
      name: 'start_time_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Start time is invalid`
  String get start_time_is_invalid {
    return Intl.message(
      'Start time is invalid',
      name: 'start_time_is_invalid',
      desc: '',
      args: [],
    );
  }

  /// `End time is required`
  String get end_time_is_required {
    return Intl.message(
      'End time is required',
      name: 'end_time_is_required',
      desc: '',
      args: [],
    );
  }

  /// `End time is invalid`
  String get end_time_is_invalid {
    return Intl.message(
      'End time is invalid',
      name: 'end_time_is_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Location is required`
  String get location_is_required {
    return Intl.message(
      'Location is required',
      name: 'location_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Date is invalid`
  String get location_is_invalid {
    return Intl.message(
      'Date is invalid',
      name: 'location_is_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Category is required`
  String get category_is_required {
    return Intl.message(
      'Category is required',
      name: 'category_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Event Added`
  String get event_added {
    return Intl.message('Event Added', name: 'event_added', desc: '', args: []);
  }

  /// `I Acknowledge`
  String get i_acknowledge {
    return Intl.message(
      'I Acknowledge',
      name: 'i_acknowledge',
      desc: '',
      args: [],
    );
  }

  /// `Edit Event`
  String get edit_event {
    return Intl.message('Edit Event', name: 'edit_event', desc: '', args: []);
  }

  /// `code copied`
  String get code_copied {
    return Intl.message('code copied', name: 'code_copied', desc: '', args: []);
  }

  /// `Start time must be before end time.`
  String get start_time_occurs {
    return Intl.message(
      'Start time must be before end time.',
      name: 'start_time_occurs',
      desc: '',
      args: [],
    );
  }

  /// `Event has been added to your Itinerary`
  String get add_itinerary_success {
    return Intl.message(
      'Event has been added to your Itinerary',
      name: 'add_itinerary_success',
      desc: '',
      args: [],
    );
  }

  /// `Itinerary updated successfully`
  String get edit_itinerary_success {
    return Intl.message(
      'Itinerary updated successfully',
      name: 'edit_itinerary_success',
      desc: '',
      args: [],
    );
  }

  /// `Explore nearby\nactivities with EVA`
  String get explore_activity_eva {
    return Intl.message(
      'Explore nearby\nactivities with EVA',
      name: 'explore_activity_eva',
      desc: '',
      args: [],
    );
  }

  /// `Any bookings from this session will be automatically added to your itinerary.`
  String get any_booking_from_this {
    return Intl.message(
      'Any bookings from this session will be automatically added to your itinerary.',
      name: 'any_booking_from_this',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to booking.com support`
  String get you_are_being {
    return Intl.message(
      'You are being redirected to booking.com support',
      name: 'you_are_being',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to ticket support`
  String get you_are_being_to_ticket {
    return Intl.message(
      'You are being redirected to ticket support',
      name: 'you_are_being_to_ticket',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to prepaid card support`
  String get you_are_being_to_prepaid {
    return Intl.message(
      'You are being redirected to prepaid card support',
      name: 'you_are_being_to_prepaid',
      desc: '',
      args: [],
    );
  }

  /// `View in Apple Wallet`
  String get view_in_apple_wallet {
    return Intl.message(
      'View in Apple Wallet',
      name: 'view_in_apple_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Card Access Begins`
  String get card_access_begins {
    return Intl.message(
      'Card Access Begins',
      name: 'card_access_begins',
      desc: '',
      args: [],
    );
  }

  /// `1 June 2026`
  String get first_june_2026 {
    return Intl.message(
      '1 June 2026',
      name: 'first_june_2026',
      desc: '',
      args: [],
    );
  }

  /// `Read Notifications`
  String get read_notifications {
    return Intl.message(
      'Read Notifications',
      name: 'read_notifications',
      desc: '',
      args: [],
    );
  }

  /// `unread Notifications`
  String get unread_notifications {
    return Intl.message(
      'unread Notifications',
      name: 'unread_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Body`
  String get body {
    return Intl.message('Body', name: 'body', desc: '', args: []);
  }

  /// `Notification Status`
  String get notification_status {
    return Intl.message(
      'Notification Status',
      name: 'notification_status',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get read {
    return Intl.message('Read', name: 'read', desc: '', args: []);
  }

  /// `Unread`
  String get unread {
    return Intl.message('Unread', name: 'unread', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `You have received a new notification`
  String get you_have_received {
    return Intl.message(
      'You have received a new notification',
      name: 'you_have_received',
      desc: '',
      args: [],
    );
  }

  /// `Checkbox`
  String get check_box {
    return Intl.message('Checkbox', name: 'check_box', desc: '', args: []);
  }

  /// `Checked`
  String get checked {
    return Intl.message('Checked', name: 'checked', desc: '', args: []);
  }

  /// `Unchecked`
  String get unchecked {
    return Intl.message('Unchecked', name: 'unchecked', desc: '', args: []);
  }

  /// `Selected`
  String get selected {
    return Intl.message('Selected', name: 'selected', desc: '', args: []);
  }

  /// `Unselected`
  String get unselected {
    return Intl.message('Unselected', name: 'unselected', desc: '', args: []);
  }

  /// `Invalid Text`
  String get invalid_text {
    return Intl.message(
      'Invalid Text',
      name: 'invalid_text',
      desc: '',
      args: [],
    );
  }

  /// `Splash Screen`
  String get splash_screen {
    return Intl.message(
      'Splash Screen',
      name: 'splash_screen',
      desc: '',
      args: [],
    );
  }

  /// `Language Selection Screen`
  String get language_selection_screen {
    return Intl.message(
      'Language Selection Screen',
      name: 'language_selection_screen',
      desc: '',
      args: [],
    );
  }

  /// `Registered Email Screen`
  String get registered_email_screen {
    return Intl.message(
      'Registered Email Screen',
      name: 'registered_email_screen',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password Screen`
  String get forgot_password_screen {
    return Intl.message(
      'Forgot Password Screen',
      name: 'forgot_password_screen',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Forgot Password Screen`
  String get confirm_forgot_password_screen {
    return Intl.message(
      'Confirm Forgot Password Screen',
      name: 'confirm_forgot_password_screen',
      desc: '',
      args: [],
    );
  }

  /// `Login Screen`
  String get login_screen {
    return Intl.message(
      'Login Screen',
      name: 'login_screen',
      desc: '',
      args: [],
    );
  }

  /// `SignUp Screen`
  String get sign_up_screen {
    return Intl.message(
      'SignUp Screen',
      name: 'sign_up_screen',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Code Screen`
  String get confirm_code_screen {
    return Intl.message(
      'Confirm Code Screen',
      name: 'confirm_code_screen',
      desc: '',
      args: [],
    );
  }

  /// `Change Password Screen`
  String get change_password_screen {
    return Intl.message(
      'Change Password Screen',
      name: 'change_password_screen',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Visa Go! We are here to help you create a once in a lifetime experience at the FIFA World Cup 26™.`
  String get welcome_message {
    return Intl.message(
      'Welcome to Visa Go! We are here to help you create a once in a lifetime experience at the FIFA World Cup 26™.',
      name: 'welcome_message',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Screen`
  String get welcome_screen {
    return Intl.message(
      'Welcome Screen',
      name: 'welcome_screen',
      desc: '',
      args: [],
    );
  }

  /// `Trip planning, recommendations and more. Our AI-powered concierge, EVA, is here to help.`
  String get greeting_screen_content {
    return Intl.message(
      'Trip planning, recommendations and more. Our AI-powered concierge, EVA, is here to help.',
      name: 'greeting_screen_content',
      desc: '',
      args: [],
    );
  }

  /// `EVA tutorial`
  String get eva_tutorial {
    return Intl.message(
      'EVA tutorial',
      name: 'eva_tutorial',
      desc: '',
      args: [],
    );
  }

  /// `Home tutorial`
  String get home_tutorial {
    return Intl.message(
      'Home tutorial',
      name: 'home_tutorial',
      desc: '',
      args: [],
    );
  }

  /// `Home Screen`
  String get home_screen {
    return Intl.message('Home Screen', name: 'home_screen', desc: '', args: []);
  }

  /// `cancel tutorial`
  String get tutorial_cancel_button {
    return Intl.message(
      'cancel tutorial',
      name: 'tutorial_cancel_button',
      desc: '',
      args: [],
    );
  }

  /// `on`
  String get on {
    return Intl.message('on', name: 'on', desc: '', args: []);
  }

  /// `in`
  String get in_key {
    return Intl.message('in', name: 'in_key', desc: '', args: []);
  }

  /// `Tap for more ticket details.`
  String get tap_for_more_ticket_details {
    return Intl.message(
      'Tap for more ticket details.',
      name: 'tap_for_more_ticket_details',
      desc: '',
      args: [],
    );
  }

  /// `No tickets is currently assigned to you.`
  String get no_tickets_semantics {
    return Intl.message(
      'No tickets is currently assigned to you.',
      name: 'no_tickets_semantics',
      desc: '',
      args: [],
    );
  }

  /// `Itinerary Screen`
  String get itinerary_screen {
    return Intl.message(
      'Itinerary Screen',
      name: 'itinerary_screen',
      desc: '',
      args: [],
    );
  }

  /// `Previous day`
  String get previous_day {
    return Intl.message(
      'Previous day',
      name: 'previous_day',
      desc: '',
      args: [],
    );
  }

  /// `Next day`
  String get next_day {
    return Intl.message('Next day', name: 'next_day', desc: '', args: []);
  }

  /// `Calendar Header`
  String get calendar_header {
    return Intl.message(
      'Calendar Header',
      name: 'calendar_header',
      desc: '',
      args: [],
    );
  }

  /// `Use navigation buttons to change months and years.`
  String get use_navigation_buttons {
    return Intl.message(
      'Use navigation buttons to change months and years.',
      name: 'use_navigation_buttons',
      desc: '',
      args: [],
    );
  }

  /// `Previous month`
  String get previous_month {
    return Intl.message(
      'Previous month',
      name: 'previous_month',
      desc: '',
      args: [],
    );
  }

  /// `Previous year`
  String get previous_year {
    return Intl.message(
      'Previous year',
      name: 'previous_year',
      desc: '',
      args: [],
    );
  }

  /// `Next year`
  String get next_year {
    return Intl.message('Next year', name: 'next_year', desc: '', args: []);
  }

  /// `Next month`
  String get next_month {
    return Intl.message('Next month', name: 'next_month', desc: '', args: []);
  }

  /// `Change calendar format`
  String get change_calendar_format {
    return Intl.message(
      'Change calendar format',
      name: 'change_calendar_format',
      desc: '',
      args: [],
    );
  }

  /// `Header long pressed`
  String get header_long_pressed {
    return Intl.message(
      'Header long pressed',
      name: 'header_long_pressed',
      desc: '',
      args: [],
    );
  }

  /// `Switched calendar format`
  String get switched_calendar_format {
    return Intl.message(
      'Switched calendar format',
      name: 'switched_calendar_format',
      desc: '',
      args: [],
    );
  }

  /// `Home Tab`
  String get home_tab {
    return Intl.message('Home Tab', name: 'home_tab', desc: '', args: []);
  }

  /// `EVA Tab`
  String get eva_tab {
    return Intl.message('EVA Tab', name: 'eva_tab', desc: '', args: []);
  }

  /// `Itinerary Tab`
  String get itinerary_tab {
    return Intl.message(
      'Itinerary Tab',
      name: 'itinerary_tab',
      desc: '',
      args: [],
    );
  }

  /// `Tickets Tab`
  String get tickets_tab {
    return Intl.message('Tickets Tab', name: 'tickets_tab', desc: '', args: []);
  }

  /// `Add Itinerary Screen`
  String get add_itinerary_screen {
    return Intl.message(
      'Add Itinerary Screen',
      name: 'add_itinerary_screen',
      desc: '',
      args: [],
    );
  }

  /// `Events cannot be scheduled in the past.`
  String get past_time {
    return Intl.message(
      'Events cannot be scheduled in the past.',
      name: 'past_time',
      desc: '',
      args: [],
    );
  }

  /// `Other {name} questions? `
  String other_booking_questions(String name) {
    return Intl.message(
      'Other $name questions? ',
      name: 'other_booking_questions',
      desc: 'other booking questions',
      args: [name],
    );
  }

  /// `View Full FAQs`
  String get view_full_faqs {
    return Intl.message(
      'View Full FAQs',
      name: 'view_full_faqs',
      desc: '',
      args: [],
    );
  }

  /// `Support Links`
  String get support_links {
    return Intl.message(
      'Support Links',
      name: 'support_links',
      desc: '',
      args: [],
    );
  }

  /// `FIFA Ticket Support`
  String get fifa_ticket_support {
    return Intl.message(
      'FIFA Ticket Support',
      name: 'fifa_ticket_support',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to `
  String get you_are_being_to {
    return Intl.message(
      'You are being redirected to ',
      name: 'you_are_being_to',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to FAQs`
  String get you_are_being_to_faqs {
    return Intl.message(
      'You are being redirected to FAQs',
      name: 'you_are_being_to_faqs',
      desc: '',
      args: [],
    );
  }

  /// `Session expiring soon`
  String get session_expiring_soon {
    return Intl.message(
      'Session expiring soon',
      name: 'session_expiring_soon',
      desc: '',
      args: [],
    );
  }

  /// `You'll be logged out in 2 minutes. Click "Stay Signed In" to continue.`
  String get you_will_be_logged_out {
    return Intl.message(
      'You\'ll be logged out in 2 minutes. Click "Stay Signed In" to continue.',
      name: 'you_will_be_logged_out',
      desc: '',
      args: [],
    );
  }

  /// `Signed out due to inactivity`
  String get signed_out_due_to_inactivity {
    return Intl.message(
      'Signed out due to inactivity',
      name: 'signed_out_due_to_inactivity',
      desc: '',
      args: [],
    );
  }

  /// `Stay Signed In`
  String get stay_signed_in {
    return Intl.message(
      'Stay Signed In',
      name: 'stay_signed_in',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to continue.`
  String get please_login_to_continue {
    return Intl.message(
      'Please log in to continue.',
      name: 'please_login_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profile_updated_successfully {
    return Intl.message(
      'Profile updated successfully',
      name: 'profile_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalid_email_id {
    return Intl.message(
      'Invalid email',
      name: 'invalid_email_id',
      desc: '',
      args: [],
    );
  }

  /// `No image available`
  String get no_image_available {
    return Intl.message(
      'No image available',
      name: 'no_image_available',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get client_error {
    return Intl.message(
      'Invalid email',
      name: 'client_error',
      desc: '',
      args: [],
    );
  }

  /// `First name is invalid`
  String get invalid_first_name_text {
    return Intl.message(
      'First name is invalid',
      name: 'invalid_first_name_text',
      desc: '',
      args: [],
    );
  }

  /// `Last name is invalid`
  String get invalid_last_name_text {
    return Intl.message(
      'Last name is invalid',
      name: 'invalid_last_name_text',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get are_you_sure {
    return Intl.message(
      'Are you sure?',
      name: 'are_you_sure',
      desc: '',
      args: [],
    );
  }

  /// `Deleting an event cannot be undone.`
  String get delete_event_can_not_undone {
    return Intl.message(
      'Deleting an event cannot be undone.',
      name: 'delete_event_can_not_undone',
      desc: '',
      args: [],
    );
  }

  /// `Accommodation`
  String get accommodation {
    return Intl.message(
      'Accommodation',
      name: 'accommodation',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activity {
    return Intl.message('Activity', name: 'activity', desc: '', args: []);
  }

  /// `Food & Drink`
  String get food_and_drink {
    return Intl.message(
      'Food & Drink',
      name: 'food_and_drink',
      desc: '',
      args: [],
    );
  }

  /// `Miscellaneous`
  String get miscellaneous {
    return Intl.message(
      'Miscellaneous',
      name: 'miscellaneous',
      desc: '',
      args: [],
    );
  }

  /// `Sightseeing`
  String get sightseeing {
    return Intl.message('Sightseeing', name: 'sightseeing', desc: '', args: []);
  }

  /// `Transportation`
  String get transportation {
    return Intl.message(
      'Transportation',
      name: 'transportation',
      desc: '',
      args: [],
    );
  }

  /// `Left`
  String get left {
    return Intl.message('Left', name: 'left', desc: '', args: []);
  }

  /// `Right`
  String get right {
    return Intl.message('Right', name: 'right', desc: '', args: []);
  }

  /// `Based on your experience, what would you like others to know? Tell the world in the app store.`
  String get based_on_your_experience {
    return Intl.message(
      'Based on your experience, what would you like others to know? Tell the world in the app store.',
      name: 'based_on_your_experience',
      desc: '',
      args: [],
    );
  }

  /// `Take Me to the App Store`
  String get take_me_to_the_app_store {
    return Intl.message(
      'Take Me to the App Store',
      name: 'take_me_to_the_app_store',
      desc: '',
      args: [],
    );
  }

  /// `Take Me to the Play Store`
  String get take_me_to_the_play_store {
    return Intl.message(
      'Take Me to the Play Store',
      name: 'take_me_to_the_play_store',
      desc: '',
      args: [],
    );
  }

  /// `Rate Visa Go`
  String get rate_visa_go {
    return Intl.message(
      'Rate Visa Go',
      name: 'rate_visa_go',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for your feedback, it helps us improve.`
  String get thanks_for_ur_feedback {
    return Intl.message(
      'Thanks for your feedback, it helps us improve.',
      name: 'thanks_for_ur_feedback',
      desc: '',
      args: [],
    );
  }

  /// `EVA chat screen opened. You can ask questions or receive suggestions here. Type your message at the bottom.`
  String get eva_chat_screen_opened {
    return Intl.message(
      'EVA chat screen opened. You can ask questions or receive suggestions here. Type your message at the bottom.',
      name: 'eva_chat_screen_opened',
      desc: '',
      args: [],
    );
  }

  /// `Message Sent`
  String get message_sent {
    return Intl.message(
      'Message Sent',
      name: 'message_sent',
      desc: '',
      args: [],
    );
  }

  /// `Message Received`
  String get message_received {
    return Intl.message(
      'Message Received',
      name: 'message_received',
      desc: '',
      args: [],
    );
  }

  /// `Sender Message`
  String get sender_message {
    return Intl.message(
      'Sender Message',
      name: 'sender_message',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Message`
  String get receiver_message {
    return Intl.message(
      'Receiver Message',
      name: 'receiver_message',
      desc: '',
      args: [],
    );
  }

  /// `Your Name Initial`
  String get your_name_initial {
    return Intl.message(
      'Your Name Initial',
      name: 'your_name_initial',
      desc: '',
      args: [],
    );
  }

  /// `Edit Message Icon`
  String get edit_message_icon {
    return Intl.message(
      'Edit Message Icon',
      name: 'edit_message_icon',
      desc: '',
      args: [],
    );
  }

  /// `Cancel editing message`
  String get cancel_editing_message {
    return Intl.message(
      'Cancel editing message',
      name: 'cancel_editing_message',
      desc: '',
      args: [],
    );
  }

  /// `Update message`
  String get update_message {
    return Intl.message(
      'Update message',
      name: 'update_message',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get temp_text {
    return Intl.message('Temperature', name: 'temp_text', desc: '', args: []);
  }

  /// `icon`
  String get icon {
    return Intl.message('icon', name: 'icon', desc: '', args: []);
  }

  /// `High`
  String get high_text {
    return Intl.message('High', name: 'high_text', desc: '', args: []);
  }

  /// `Low`
  String get low_text {
    return Intl.message('Low', name: 'low_text', desc: '', args: []);
  }

  /// `Weather Condition`
  String get weather_condition {
    return Intl.message(
      'Weather Condition',
      name: 'weather_condition',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Seven-day weather forecast for`
  String get seven_day_forecast_for {
    return Intl.message(
      'Seven-day weather forecast for',
      name: 'seven_day_forecast_for',
      desc: '',
      args: [],
    );
  }

  /// `No image available for`
  String get no_image_available_for {
    return Intl.message(
      'No image available for',
      name: 'no_image_available_for',
      desc: '',
      args: [],
    );
  }

  /// `Image of`
  String get image_of {
    return Intl.message('Image of', name: 'image_of', desc: '', args: []);
  }

  /// `View details about`
  String get view_details_about {
    return Intl.message(
      'View details about',
      name: 'view_details_about',
      desc: '',
      args: [],
    );
  }

  /// `for`
  String get for_text {
    return Intl.message('for', name: 'for_text', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `Editorial Summary`
  String get editorial_summary {
    return Intl.message(
      'Editorial Summary',
      name: 'editorial_summary',
      desc: '',
      args: [],
    );
  }

  /// `Primary Type`
  String get primary_type {
    return Intl.message(
      'Primary Type',
      name: 'primary_type',
      desc: '',
      args: [],
    );
  }

  /// `Place name`
  String get place_name {
    return Intl.message('Place name', name: 'place_name', desc: '', args: []);
  }

  /// `Hotel name`
  String get hotel_name {
    return Intl.message('Hotel name', name: 'hotel_name', desc: '', args: []);
  }

  /// `Conversation history screen`
  String get eva_chat_history_screen {
    return Intl.message(
      'Conversation history screen',
      name: 'eva_chat_history_screen',
      desc: '',
      args: [],
    );
  }

  /// `Visa Logo`
  String get visa_logo {
    return Intl.message('Visa Logo', name: 'visa_logo', desc: '', args: []);
  }

  /// `Chat history updated`
  String get chat_history_updated {
    return Intl.message(
      'Chat history updated',
      name: 'chat_history_updated',
      desc: '',
      args: [],
    );
  }

  /// `Liked the message`
  String get liked_the_message {
    return Intl.message(
      'Liked the message',
      name: 'liked_the_message',
      desc: '',
      args: [],
    );
  }

  /// `Removed like`
  String get removed_like {
    return Intl.message(
      'Removed like',
      name: 'removed_like',
      desc: '',
      args: [],
    );
  }

  /// `Changed to like`
  String get changed_to_like {
    return Intl.message(
      'Changed to like',
      name: 'changed_to_like',
      desc: '',
      args: [],
    );
  }

  /// `Changed to dislike`
  String get changed_to_dislike {
    return Intl.message(
      'Changed to dislike',
      name: 'changed_to_dislike',
      desc: '',
      args: [],
    );
  }

  /// `Removed dislike`
  String get removed_dislike {
    return Intl.message(
      'Removed dislike',
      name: 'removed_dislike',
      desc: '',
      args: [],
    );
  }

  /// `Disliked the message`
  String get disliked_the_message {
    return Intl.message(
      'Disliked the message',
      name: 'disliked_the_message',
      desc: '',
      args: [],
    );
  }

  /// `Open App Store`
  String get open_app_store {
    return Intl.message(
      'Open App Store',
      name: 'open_app_store',
      desc: '',
      args: [],
    );
  }

  /// `Open Play Store`
  String get open_play_store {
    return Intl.message(
      'Open Play Store',
      name: 'open_play_store',
      desc: '',
      args: [],
    );
  }

  /// `Contact Support`
  String get contact_visa_support {
    return Intl.message(
      'Contact Support',
      name: 'contact_visa_support',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Go to Profile`
  String get open_profile {
    return Intl.message(
      'Go to Profile',
      name: 'open_profile',
      desc: '',
      args: [],
    );
  }

  /// `Open Wallet`
  String get open_wallet {
    return Intl.message('Open Wallet', name: 'open_wallet', desc: '', args: []);
  }

  /// `Open FAQs`
  String get open_faq {
    return Intl.message('Open FAQs', name: 'open_faq', desc: '', args: []);
  }

  /// `Prepaid Card`
  String get open_prepaid_card {
    return Intl.message(
      'Prepaid Card',
      name: 'open_prepaid_card',
      desc: '',
      args: [],
    );
  }

  /// `EVA Chat`
  String get open_eva_chat {
    return Intl.message('EVA Chat', name: 'open_eva_chat', desc: '', args: []);
  }

  /// `Go to Tickets`
  String get open_ticket {
    return Intl.message(
      'Go to Tickets',
      name: 'open_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Companion`
  String get open_companion {
    return Intl.message(
      'Companion',
      name: 'open_companion',
      desc: '',
      args: [],
    );
  }

  /// `Book Travel`
  String get open_book_travel {
    return Intl.message(
      'Book Travel',
      name: 'open_book_travel',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to the Visa Go Website`
  String get redirect_to_visa_go_website {
    return Intl.message(
      'You are being redirected to the Visa Go Website',
      name: 'redirect_to_visa_go_website',
      desc: '',
      args: [],
    );
  }

  /// `You are being redirected to VISA Go Support`
  String get you_are_being_redirect_to_visa_contact_us_support {
    return Intl.message(
      'You are being redirected to VISA Go Support',
      name: 'you_are_being_redirect_to_visa_contact_us_support',
      desc: '',
      args: [],
    );
  }

  /// `FAQ Screen`
  String get faq_screen {
    return Intl.message('FAQ Screen', name: 'faq_screen', desc: '', args: []);
  }

  /// `Double tap to expand or collapse.`
  String get double_tap_to_collapse_expand {
    return Intl.message(
      'Double tap to expand or collapse.',
      name: 'double_tap_to_collapse_expand',
      desc: '',
      args: [],
    );
  }

  /// `Expanded`
  String get expanded {
    return Intl.message('Expanded', name: 'expanded', desc: '', args: []);
  }

  /// `Collapsed`
  String get collapsed {
    return Intl.message('Collapsed', name: 'collapsed', desc: '', args: []);
  }

  /// `Redirected Screen`
  String get redirected_screen {
    return Intl.message(
      'Redirected Screen',
      name: 'redirected_screen',
      desc: '',
      args: [],
    );
  }

  /// `Double tap to select location`
  String get double_tap_to_select_location {
    return Intl.message(
      'Double tap to select location',
      name: 'double_tap_to_select_location',
      desc: '',
      args: [],
    );
  }

  /// `Time remaining for world cup {day} days {hour} hours and {sec} seconds`
  String time_remaining_for_world_cup(String day, String hour, String sec) {
    return Intl.message(
      'Time remaining for world cup $day days $hour hours and $sec seconds',
      name: 'time_remaining_for_world_cup',
      desc: 'Time remaining for world cup',
      args: [day, hour, sec],
    );
  }

  /// `Enter the email address associated with your Visa Go invitation.`
  String get guide_for_email {
    return Intl.message(
      'Enter the email address associated with your Visa Go invitation.',
      name: 'guide_for_email',
      desc: '',
      args: [],
    );
  }

  /// `EVA's response has been copied.`
  String get eva_copy {
    return Intl.message(
      'EVA\'s response has been copied.',
      name: 'eva_copy',
      desc: '',
      args: [],
    );
  }

  /// `Unsupported Device Detected`
  String get unsupported_device_detected {
    return Intl.message(
      'Unsupported Device Detected',
      name: 'unsupported_device_detected',
      desc: '',
      args: [],
    );
  }

  /// `Oops! For security reasons, this app doesn't work while Developer Mode is on. Please disable Developer Mode in your phone's settings and try again.`
  String get developer_mode_description {
    return Intl.message(
      'Oops! For security reasons, this app doesn\'t work while Developer Mode is on. Please disable Developer Mode in your phone\'s settings and try again.',
      name: 'developer_mode_description',
      desc: '',
      args: [],
    );
  }

  /// `Close Tutorial`
  String get close_tutorial {
    return Intl.message(
      'Close Tutorial',
      name: 'close_tutorial',
      desc: '',
      args: [],
    );
  }

  /// `For your security, this app does not support rooted or jailbroken devices.`
  String get unsupported_device_description {
    return Intl.message(
      'For your security, this app does not support rooted or jailbroken devices.',
      name: 'unsupported_device_description',
      desc: '',
      args: [],
    );
  }

  /// `is on`
  String get is_on {
    return Intl.message('is on', name: 'is_on', desc: '', args: []);
  }

  /// `is off`
  String get is_off {
    return Intl.message('is off', name: 'is_off', desc: '', args: []);
  }

  /// `Previous week`
  String get previous_week {
    return Intl.message(
      'Previous week',
      name: 'previous_week',
      desc: '',
      args: [],
    );
  }

  /// `Next week`
  String get next_week {
    return Intl.message('Next week', name: 'next_week', desc: '', args: []);
  }

  /// `Calendar`
  String get calendar {
    return Intl.message('Calendar', name: 'calendar', desc: '', args: []);
  }

  /// `Expand`
  String get expand {
    return Intl.message('Expand', name: 'expand', desc: '', args: []);
  }

  /// `Collapse`
  String get collapse {
    return Intl.message('Collapse', name: 'collapse', desc: '', args: []);
  }

  /// `More details link, expands`
  String get more_details_link {
    return Intl.message(
      'More details link, expands',
      name: 'more_details_link',
      desc: '',
      args: [],
    );
  }

  /// `event information`
  String get event_information {
    return Intl.message(
      'event information',
      name: 'event_information',
      desc: '',
      args: [],
    );
  }

  /// `Category, required`
  String get category_required {
    return Intl.message(
      'Category, required',
      name: 'category_required',
      desc: '',
      args: [],
    );
  }

  /// `Text Field`
  String get text_field {
    return Intl.message('Text Field', name: 'text_field', desc: '', args: []);
  }

  /// `Double tap to edit.`
  String get double_tap_to_edit {
    return Intl.message(
      'Double tap to edit.',
      name: 'double_tap_to_edit',
      desc: '',
      args: [],
    );
  }

  /// `Date Field`
  String get date_field {
    return Intl.message('Date Field', name: 'date_field', desc: '', args: []);
  }

  /// `Start Time`
  String get start_time_field {
    return Intl.message(
      'Start Time',
      name: 'start_time_field',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get end_time_field {
    return Intl.message('End Time', name: 'end_time_field', desc: '', args: []);
  }

  /// `Password hidden`
  String get password_hidden {
    return Intl.message(
      'Password hidden',
      name: 'password_hidden',
      desc: '',
      args: [],
    );
  }

  /// `Password shown`
  String get password_visible {
    return Intl.message(
      'Password shown',
      name: 'password_visible',
      desc: '',
      args: [],
    );
  }

  /// `Double tap to select`
  String get double_tap_to_select {
    return Intl.message(
      'Double tap to select',
      name: 'double_tap_to_select',
      desc: '',
      args: [],
    );
  }

  /// `Double tap to unselect`
  String get double_tap_to_unselect {
    return Intl.message(
      'Double tap to unselect',
      name: 'double_tap_to_unselect',
      desc: '',
      args: [],
    );
  }

  /// `Edit event details, button`
  String get edit_event_details_button {
    return Intl.message(
      'Edit event details, button',
      name: 'edit_event_details_button',
      desc: '',
      args: [],
    );
  }

  /// `Dialog`
  String get dialog {
    return Intl.message('Dialog', name: 'dialog', desc: '', args: []);
  }

  /// `button, double tap to activate`
  String get double_tap_to_activate {
    return Intl.message(
      'button, double tap to activate',
      name: 'double_tap_to_activate',
      desc: '',
      args: [],
    );
  }

  /// `Your package includes:`
  String get your_package_includes {
    return Intl.message(
      'Your package includes:',
      name: 'your_package_includes',
      desc: '',
      args: [],
    );
  }

  /// `tickets to`
  String get tickets_to {
    return Intl.message('tickets to', name: 'tickets_to', desc: '', args: []);
  }

  /// `travel credit`
  String get travel_credit {
    return Intl.message(
      'travel credit',
      name: 'travel_credit',
      desc: '',
      args: [],
    );
  }

  /// `Prepaid card`
  String get prepaid_card_package {
    return Intl.message(
      'Prepaid card',
      name: 'prepaid_card_package',
      desc: '',
      args: [],
    );
  }

  /// `Companion Screen`
  String get companion_screen {
    return Intl.message(
      'Companion Screen',
      name: 'companion_screen',
      desc: '',
      args: [],
    );
  }

  /// `Companion Details Screen`
  String get companion_details_screen {
    return Intl.message(
      'Companion Details Screen',
      name: 'companion_details_screen',
      desc: '',
      args: [],
    );
  }

  /// `checkbox`
  String get checkbox {
    return Intl.message('checkbox', name: 'checkbox', desc: '', args: []);
  }

  /// `I acknowledge`
  String get i_acknowledge_label {
    return Intl.message(
      'I acknowledge',
      name: 'i_acknowledge_label',
      desc: '',
      args: [],
    );
  }

  /// `Give permission`
  String get give_permission_label {
    return Intl.message(
      'Give permission',
      name: 'give_permission_label',
      desc: '',
      args: [],
    );
  }

  /// `Detail Card`
  String get detail_card {
    return Intl.message('Detail Card', name: 'detail_card', desc: '', args: []);
  }

  /// `Delete Companion Dialog`
  String get delete_companion_dialog {
    return Intl.message(
      'Delete Companion Dialog',
      name: 'delete_companion_dialog',
      desc: '',
      args: [],
    );
  }

  /// `Thinking...`
  String get thinking {
    return Intl.message('Thinking...', name: 'thinking', desc: '', args: []);
  }

  /// `Gathering info...`
  String get gathering_info {
    return Intl.message(
      'Gathering info...',
      name: 'gathering_info',
      desc: '',
      args: [],
    );
  }

  /// `Searching...`
  String get searching {
    return Intl.message('Searching...', name: 'searching', desc: '', args: []);
  }

  /// `Version`
  String get app_version {
    return Intl.message('Version', name: 'app_version', desc: '', args: []);
  }

  /// `You've reached the limit. This match can only be reassigned users.`
  String get companion_capacity_full {
    return Intl.message(
      'You\'ve reached the limit. This match can only be reassigned users.',
      name: 'companion_capacity_full',
      desc: '',
      args: [],
    );
  }

  /// `User cannot add themselves as a companion.`
  String get self_companion_not_allowed {
    return Intl.message(
      'User cannot add themselves as a companion.',
      name: 'self_companion_not_allowed',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get of_question {
    return Intl.message('of', name: 'of_question', desc: '', args: []);
  }

  /// `Switch User`
  String get change_email_id {
    return Intl.message(
      'Switch User',
      name: 'change_email_id',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }

  /// `Select time in 24-hour format. Example: zero zero colon zero zero`
  String get zero_colon_format {
    return Intl.message(
      'Select time in 24-hour format. Example: zero zero colon zero zero',
      name: 'zero_colon_format',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message('Optional', name: 'optional', desc: '', args: []);
  }

  /// `Edit language Screen`
  String get edit_language_screen {
    return Intl.message(
      'Edit language Screen',
      name: 'edit_language_screen',
      desc: '',
      args: [],
    );
  }

  /// `Frequently Asked Questions`
  String get frequently_asked_questions {
    return Intl.message(
      'Frequently Asked Questions',
      name: 'frequently_asked_questions',
      desc: '',
      args: [],
    );
  }

  /// `Login to view the complete list`
  String get login_to_view_the_complete_list {
    return Intl.message(
      'Login to view the complete list',
      name: 'login_to_view_the_complete_list',
      desc: '',
      args: [],
    );
  }

  /// `Login to view full FAQs`
  String get login_to_view_full_faqs {
    return Intl.message(
      'Login to view full FAQs',
      name: 'login_to_view_full_faqs',
      desc: '',
      args: [],
    );
  }

  /// `TYPE TO SEARCH`
  String get type_to_search {
    return Intl.message(
      'TYPE TO SEARCH',
      name: 'type_to_search',
      desc: '',
      args: [],
    );
  }

  /// `Visa Go Support`
  String get visa_go_support {
    return Intl.message(
      'Visa Go Support',
      name: 'visa_go_support',
      desc: '',
      args: [],
    );
  }

  /// `contact@visago.com`
  String get contact_visa_go_com {
    return Intl.message(
      'contact@visago.com',
      name: 'contact_visa_go_com',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get whatsApp {
    return Intl.message('WhatsApp', name: 'whatsApp', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Thanks Screen`
  String get thanks_screen {
    return Intl.message(
      'Thanks Screen',
      name: 'thanks_screen',
      desc: '',
      args: [],
    );
  }

  /// `Profile Tab`
  String get profile_tab {
    return Intl.message('Profile Tab', name: 'profile_tab', desc: '', args: []);
  }

  /// `Notification Tab`
  String get notification_tab {
    return Intl.message(
      'Notification Tab',
      name: 'notification_tab',
      desc: '',
      args: [],
    );
  }

  /// `EVA Conversation History Tab`
  String get eva_history_tab {
    return Intl.message(
      'EVA Conversation History Tab',
      name: 'eva_history_tab',
      desc: '',
      args: [],
    );
  }

  /// `FAQ Tab`
  String get faq_tab {
    return Intl.message('FAQ Tab', name: 'faq_tab', desc: '', args: []);
  }

  /// `Security Warning`
  String get security_warning {
    return Intl.message(
      'Security Warning',
      name: 'security_warning',
      desc: 'Title for security warning dialog',
      args: [],
    );
  }

  /// `This URL is not allowed for security reasons. Only HTTPS URLs and trusted domains are permitted.`
  String get security_warning_message {
    return Intl.message(
      'This URL is not allowed for security reasons. Only HTTPS URLs and trusted domains are permitted.',
      name: 'security_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `Click anywhere on screen or drag slider to adjust excitement level`
  String get slider_hint_web {
    return Intl.message(
      'Click anywhere on screen or drag slider to adjust excitement level',
      name: 'slider_hint_web',
      desc: '',
      args: [],
    );
  }

  /// `Tap anywhere on screen or drag slider to adjust excitement level`
  String get slider_hint_app {
    return Intl.message(
      'Tap anywhere on screen or drag slider to adjust excitement level',
      name: 'slider_hint_app',
      desc: '',
      args: [],
    );
  }

  /// `link, double tap to activate`
  String get double_tap_to_activate_link {
    return Intl.message(
      'link, double tap to activate',
      name: 'double_tap_to_activate_link',
      desc: '',
      args: [],
    );
  }

  /// `button. double tap to expand and view more dates`
  String get double_tap_to_expand {
    return Intl.message(
      'button. double tap to expand and view more dates',
      name: 'double_tap_to_expand',
      desc: '',
      args: [],
    );
  }

  /// `button. double tap to collapse`
  String get double_tap_to_collapse {
    return Intl.message(
      'button. double tap to collapse',
      name: 'double_tap_to_collapse',
      desc: '',
      args: [],
    );
  }

  /// `No letter provided. Please type or select a letter to find a team.`
  String get empty_team_text {
    return Intl.message(
      'No letter provided. Please type or select a letter to find a team.',
      name: 'empty_team_text',
      desc: '',
      args: [],
    );
  }

  /// `No team found starting with`
  String get no_team_found {
    return Intl.message(
      'No team found starting with',
      name: 'no_team_found',
      desc: '',
      args: [],
    );
  }

  /// `card`
  String get card {
    return Intl.message('card', name: 'card', desc: '', args: []);
  }

  /// `Conversation deleted successfully.`
  String get conversation_delete {
    return Intl.message(
      'Conversation deleted successfully.',
      name: 'conversation_delete',
      desc: '',
      args: [],
    );
  }

  /// `More details button, expands`
  String get more_details_button {
    return Intl.message(
      'More details button, expands',
      name: 'more_details_button',
      desc: '',
      args: [],
    );
  }

  /// `Max Attempts Exceeded`
  String get max_attempts_exceeded {
    return Intl.message(
      'Max Attempts Exceeded',
      name: 'max_attempts_exceeded',
      desc: '',
      args: [],
    );
  }

  /// `attempts left`
  String get attempts_left {
    return Intl.message(
      'attempts left',
      name: 'attempts_left',
      desc: '',
      args: [],
    );
  }

  /// `Countdown to FIFA World Cup:`
  String get countdown_to_fifa_word_cup {
    return Intl.message(
      'Countdown to FIFA World Cup:',
      name: 'countdown_to_fifa_word_cup',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get hours {
    return Intl.message('hours', name: 'hours', desc: '', args: []);
  }

  /// `minutes`
  String get minutes {
    return Intl.message('minutes', name: 'minutes', desc: '', args: []);
  }

  /// `attempt left`
  String get attempt_left {
    return Intl.message(
      'attempt left',
      name: 'attempt_left',
      desc: '',
      args: [],
    );
  }

  /// `Attention Required`
  String get attention_required {
    return Intl.message(
      'Attention Required',
      name: 'attention_required',
      desc: '',
      args: [],
    );
  }

  /// `You are nearing your companion change limit:`
  String get you_are_nearing_your {
    return Intl.message(
      'You are nearing your companion change limit:',
      name: 'you_are_nearing_your',
      desc: '',
      args: [],
    );
  }

  /// `You’ve reached the companion change limit for a match`
  String get you_reached_the_companion_change {
    return Intl.message(
      'You’ve reached the companion change limit for a match',
      name: 'you_reached_the_companion_change',
      desc: '',
      args: [],
    );
  }

  /// `limit exhausted`
  String get limit_exhausted {
    return Intl.message(
      'limit exhausted',
      name: 'limit_exhausted',
      desc: '',
      args: [],
    );
  }

  /// `send`
  String get send {
    return Intl.message('send', name: 'send', desc: '', args: []);
  }

  /// `1 of 4`
  String get one_of_four {
    return Intl.message('1 of 4', name: 'one_of_four', desc: '', args: []);
  }

  /// `2 of 4`
  String get two_of_four {
    return Intl.message('2 of 4', name: 'two_of_four', desc: '', args: []);
  }

  /// `3 of 4`
  String get three_of_four {
    return Intl.message('3 of 4', name: 'three_of_four', desc: '', args: []);
  }

  /// `4 of 4`
  String get four_of_four {
    return Intl.message('4 of 4', name: 'four_of_four', desc: '', args: []);
  }

  /// `edit box`
  String get edit_box {
    return Intl.message('edit box', name: 'edit_box', desc: '', args: []);
  }

  /// `fifa world cup 26`
  String get fifa_word_cup_semantic_label {
    return Intl.message(
      'fifa world cup 26',
      name: 'fifa_word_cup_semantic_label',
      desc: '',
      args: [],
    );
  }

  /// `welcome to visa go! we are here to help you create a once in a lifetime experience at the fifa world cup 26`
  String get welcome_message_semantic_label {
    return Intl.message(
      'welcome to visa go! we are here to help you create a once in a lifetime experience at the fifa world cup 26',
      name: 'welcome_message_semantic_label',
      desc: '',
      args: [],
    );
  }

  /// `adding a companion is optional. companions will only have access to the visa go app. all tickets are issued to your via the fifa app. you do not have to add a companion in visa go in order to take someone to the fifa world cup 26`
  String get adding_a_companion_is_optional_semantic_label {
    return Intl.message(
      'adding a companion is optional. companions will only have access to the visa go app. all tickets are issued to your via the fifa app. you do not have to add a companion in visa go in order to take someone to the fifa world cup 26',
      name: 'adding_a_companion_is_optional_semantic_label',
      desc: '',
      args: [],
    );
  }

  /// `View Full`
  String get view_full {
    return Intl.message('View Full', name: 'view_full', desc: '', args: []);
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Itinerary removed successfully.`
  String get itinerary_deleted_success {
    return Intl.message(
      'Itinerary removed successfully.',
      name: 'itinerary_deleted_success',
      desc: '',
      args: [],
    );
  }

  /// `registered email`
  String get registered_email {
    return Intl.message(
      'registered email',
      name: 'registered_email',
      desc: '',
      args: [],
    );
  }

  /// `non editable`
  String get non_editable {
    return Intl.message(
      'non editable',
      name: 'non_editable',
      desc: '',
      args: [],
    );
  }

  /// `please complete all required fields to enable`
  String get disabled_button_text_field_label {
    return Intl.message(
      'please complete all required fields to enable',
      name: 'disabled_button_text_field_label',
      desc: '',
      args: [],
    );
  }

  /// `Registered email, not editable,`
  String get email_not_editable {
    return Intl.message(
      'Registered email, not editable,',
      name: 'email_not_editable',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile. Button. Double-tap to edit your profile information.`
  String get edit_button_description {
    return Intl.message(
      'Edit profile. Button. Double-tap to edit your profile information.',
      name: 'edit_button_description',
      desc: '',
      args: [],
    );
  }

  /// `Loading, please wait`
  String get loading_wait {
    return Intl.message(
      'Loading, please wait',
      name: 'loading_wait',
      desc: '',
      args: [],
    );
  }

  /// `Notifications button, {count} new messages`
  String notification_count(int count) {
    return Intl.message(
      'Notifications button, $count new messages',
      name: 'notification_count',
      desc: 'Notification count with dynamic number',
      args: [count],
    );
  }

  /// `Expand ticket details`
  String get expand_details {
    return Intl.message(
      'Expand ticket details',
      name: 'expand_details',
      desc: '',
      args: [],
    );
  }

  /// `Collapse ticket details`
  String get collapse_details {
    return Intl.message(
      'Collapse ticket details',
      name: 'collapse_details',
      desc: '',
      args: [],
    );
  }

  /// `No changes detected. Please update the form to proceed.`
  String get no_change_detected_message_in_form {
    return Intl.message(
      'No changes detected. Please update the form to proceed.',
      name: 'no_change_detected_message_in_form',
      desc: '',
      args: [],
    );
  }

  /// `No changes detected. Please update language to proceed.`
  String get no_change_detected_message_in_language {
    return Intl.message(
      'No changes detected. Please update language to proceed.',
      name: 'no_change_detected_message_in_language',
      desc: '',
      args: [],
    );
  }

  /// `Help Us Improve`
  String get help_us_improve {
    return Intl.message(
      'Help Us Improve',
      name: 'help_us_improve',
      desc: '',
      args: [],
    );
  }

  /// `Allow anonymous analytics to help us enhance your experience.`
  String get allow_anonymous_analytics {
    return Intl.message(
      'Allow anonymous analytics to help us enhance your experience.',
      name: 'allow_anonymous_analytics',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get allow {
    return Intl.message('Allow', name: 'allow', desc: '', args: []);
  }

  /// `Decline`
  String get decline {
    return Intl.message('Decline', name: 'decline', desc: '', args: []);
  }

  /// `Analytics Consent`
  String get analytics_consent {
    return Intl.message(
      'Analytics Consent',
      name: 'analytics_consent',
      desc: '',
      args: [],
    );
  }

  /// `Analytics preference updated successfully`
  String get analytics_consent_success {
    return Intl.message(
      'Analytics preference updated successfully',
      name: 'analytics_consent_success',
      desc: '',
      args: [],
    );
  }

  /// `Read More`
  String get read_more {
    return Intl.message('Read More', name: 'read_more', desc: '', args: []);
  }

  /// `Learn More`
  String get learn_more {
    return Intl.message('Learn More', name: 'learn_more', desc: '', args: []);
  }

  /// `Invalid Authentication code. Please review the code you entered and try again.`
  String get invalid_auth_code {
    return Intl.message(
      'Invalid Authentication code. Please review the code you entered and try again.',
      name: 'invalid_auth_code',
      desc: '',
      args: [],
    );
  }

  /// `Update Available`
  String get update_available {
    return Intl.message(
      'Update Available',
      name: 'update_available',
      desc: '',
      args: [],
    );
  }

  /// `A newer version of the app is ready. Update now for a better experience.`
  String get a_newer_version_of_app {
    return Intl.message(
      'A newer version of the app is ready. Update now for a better experience.',
      name: 'a_newer_version_of_app',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get update_ {
    return Intl.message('Update Now', name: 'update_', desc: '', args: []);
  }

  /// `Remind Me Later`
  String get remind_me_later {
    return Intl.message(
      'Remind Me Later',
      name: 'remind_me_later',
      desc: '',
      args: [],
    );
  }

  /// `Update Required`
  String get update_required {
    return Intl.message(
      'Update Required',
      name: 'update_required',
      desc: '',
      args: [],
    );
  }

  /// `You need to update the app to continue.`
  String get you_need_to_update {
    return Intl.message(
      'You need to update the app to continue.',
      name: 'you_need_to_update',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get update_now {
    return Intl.message('Update Now', name: 'update_now', desc: '', args: []);
  }

  /// `No Changes Detected`
  String get no_changes_detected {
    return Intl.message(
      'No Changes Detected',
      name: 'no_changes_detected',
      desc: '',
      args: [],
    );
  }

  /// `You haven’t made any changes to update the event.`
  String get no_change_in_event {
    return Intl.message(
      'You haven’t made any changes to update the event.',
      name: 'no_change_in_event',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
