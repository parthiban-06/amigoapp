import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visaamigo/core/config/env_config.dart';
import 'package:visaamigo/custom_widgets/generic_dialog.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';
import 'package:visaamigo/features/itinerary/models/add_itinerary_model.dart';
import 'package:visaamigo/features/itinerary/models/itinerary_location_search_model.dart';
import 'package:visaamigo/features/itinerary/models/timezone_model.dart';
import 'package:visaamigo/features/rate_us/widgets/rateus_popup.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/date_util.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../core/theme/theme.dart';
import '../../../ui/base/base_provider.dart';
import '../../itinerary/providers/itinerary_provider.dart';
import '../models/event_list_model.dart';
import '../repo/itineary_repo.dart';

/// Provider for managing add/edit itinerary functionality
class AddItineraryProvider extends BaseProvider {
  // Constants
  static const String _timeFormat24Hour = 'HH:mm';
  static const String _timeFormat12Hour = 'hh:mm a';

  // Form controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController eventName = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();
  final TextEditingController locationEdt = TextEditingController();
  final TextEditingController description = TextEditingController();

  // UI controllers
  final GlobalKey categoryErrorSectionKey = GlobalKey();
  final ScrollController addItineraryController = ScrollController();

  // Time and date fields
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? calendarDateTime = DateTime.now();
  bool is24hrsClockEnable = true;

  // Repository instances
  ItineraryRepo? _itineraryRepo;
  UserDetailRepo? _userDetailRepo;

  // Location and timezone data
  String? languageCode;
  PlaceResponse? placePredictions;
  String timezoneOffset = "";
  String? event_time_zone_id;
  String? event_time_zone;
  String? event_dst_offset;
  int? event_raw_offset;
  double? event_latitude;
  double? event_longitude;

  // State management
  bool isUpdate = false;
  bool showError = false;
  List<String> formValid = [];
  List<Map<String, dynamic>> formError = [];
  String? errorText;
  String? errorTextStart;
  bool isDisable = true;
  bool showCategoryError = false;

  // Dependencies
  ItineraryProvider? itineraryProvider;
  EventModel? _eventModel;
  String? location;

  // Category list
  List<Options> categoryList = [];

  /// Gets the itinerary repository instance
  ItineraryRepo? get itineraryRepo => _itineraryRepo;

  /// Gets the user detail repository instance
  UserDetailRepo? get userDetailRepo => _userDetailRepo;

  /// Initializes the provider with event data and dependencies
  Future<void> init(EventList? eventModel, ItineraryProvider itineraryProvider,
      String? location, String? dateTime) async {
    await _initializeCategoryList();
    await _initializeRepositories();
    await _initializePreferences();

    this.itineraryProvider = itineraryProvider;
    _eventModel = eventModel?.toEventModel();

    _logAnalyticsEvent();

    await _handleLocationInitialization(location);
    await _handleDateTimeInitialization(dateTime);
    await _handleEventModelInitialization(eventModel);
  }

  /// Initializes the category list
  Future<void> _initializeCategoryList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryList = _createCategoryList();
      setState();
    });
  }

  /// Creates the category list with localized names
  List<Options> _createCategoryList() {
    return [
      Options(
        optionId: AppConst.ITINERARY_CATEGORY_ACCOMMODATION,
        optionName: S.of(getContext()).accommodation,
        isSelected: false,
      ),
      Options(
        optionName: S.of(getContext()).activity,
        isSelected: false,
        optionId: AppConst.ITINERARY_CATEGORY_ACTIVITY,
      ),
      Options(
        optionId: AppConst.ITINERARY_CATEGORY_FOOD,
        optionName: S.of(getContext()).food_and_drink,
        isSelected: false,
      ),
      Options(
        optionId: AppConst.ITINERARY_CATEGORY_MISCELLANEOUS,
        optionName: S.of(getContext()).miscellaneous,
        isSelected: false,
      ),
      Options(
        optionId: AppConst.ITINERARY_CATEGORY_SIGHTSEEING,
        optionName: S.of(getContext()).sightseeing,
        isSelected: false,
      ),
      Options(
        optionId: AppConst.ITINERARY_CATEGORY_TRANSPORTATION,
        optionName: S.of(getContext()).transportation,
        isSelected: false,
      ),
    ];
  }

  /// Initializes repository instances
  Future<void> _initializeRepositories() async {
    languageCode = await Preferences.getString(Preferences.keyLanguageCode);
    _itineraryRepo = ItineraryRepo(apiClient);
  }

  /// Initializes user preferences
  Future<void> _initializePreferences() async {
    is24hrsClockEnable = await Preferences.getBool(Preferences.KeyIs24Time);
    Utils.logPrint("is24hrsClockEnable $is24hrsClockEnable");
  }

  /// Handles location initialization
  Future<void> _handleLocationInitialization(String? location) async {
    if (_eventModel == null && location != null && location.isNotEmpty) {
      locationEdt.text = location;
      await fetchSuggestions(location);
    }
  }

  /// Handles date time initialization
  Future<void> _handleDateTimeInitialization(String? dateTime) async {
    if (dateTime != null && dateTime.isNotEmpty) {
      date.text = DateUtil.formatFull(mContext, DateTime.parse(dateTime));
      calendarDateTime = DateTime.parse(dateTime);
    }
  }

  /// Handles event model initialization
  Future<void> _handleEventModelInitialization(EventList? eventModel) async {
    Utils.logPrint("_handleEventModelInitialization ${eventModel?.toJson()}");
    if (eventModel == null) {
      _logAnalyticsEvent();
      // added to set miscellaneous active default
      updateEditState();
      changeCategoryList(3);
      return;
    }

    _populateEventData(eventModel);
    _populateCategorySelection(eventModel);
    _populateLocationData(eventModel);
    _populateTimeData(eventModel);

    checkDisable();
  }

  /// Populates event data from the model
  void _populateEventData(EventList eventModel) {
    eventName.text = eventModel.title ?? "";
    locationEdt.text = eventModel.address ?? "";
    description.text = eventModel.description ?? "";
    calendarDateTime = DateTime.parse(eventModel.eventDate!);
    date.text =
        DateUtil.formatFull(mContext, DateTime.parse(eventModel.eventDate!));
  }

  /// Populates category selection
  void _populateCategorySelection(EventList eventModel) {
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList.elementAt(i).optionId == eventModel.eventCategory) {
        categoryList.elementAt(i).isSelected = true;
      }
    }
  }

  /// Populates location data
  void _populateLocationData(EventList eventModel) {
    event_latitude = eventModel.lat;
    event_longitude = eventModel.lan;
  }

  /// Populates time data from the model
  void _populateTimeData(EventList eventModel) {
    _populateStartTime(eventModel);
    _populateEndTime(eventModel);
  }

  /// Populates start time data
  void _populateStartTime(EventList eventModel) {
    if (eventModel.startTime == null) return;

    final cleanStartTime = eventModel.startTime!.split(RegExp(r'[+-]')).first;
    startTime =
        TimeOfDay.fromDateTime(DateTime.parse("2025-01-01T$cleanStartTime"));

    timezoneOffset = eventModel.startTime.substring(
      eventModel.startTime.indexOf(RegExp(r'[+-]')),
    );

    final dtStart = DateTime.parse("2025-01-01T$cleanStartTime");
    start.text =
        DateFormat(is24hrsClockEnable ? _timeFormat24Hour : _timeFormat12Hour)
            .format(dtStart);

    Utils.logPrint("startTime startTime -- $startTime");
  }

  /// Populates end time data
  void _populateEndTime(EventList eventModel) {
    if (eventModel.endTime == null || eventModel.endTime!.isEmpty) return;

    final cleanStartTime = eventModel.endTime!.split(RegExp(r'[+-]')).first;
    endTime =
        TimeOfDay.fromDateTime(DateTime.parse("2025-01-01T$cleanStartTime"));

    final dtStart = DateTime.parse("2025-01-01T$cleanStartTime");
    end.text =
        DateFormat(is24hrsClockEnable ? _timeFormat24Hour : _timeFormat12Hour)
            .format(dtStart);
  }

  /// Logs analytics event for form start
  void _logAnalyticsEvent() {
    FirebaseAnalyticsService.logEvent(
        eventName: !(_eventModel == null)
            ? "itineraryCreation.editEvent.formstart"
            : "itineraryCreation.addNewEvent.formstart",
        parameters: {
          AnalyticsEventConst.FORM_NAME: !(_eventModel == null)
              ? "edit_event_itinerary"
              : "add_new_event_itinerary",
          AnalyticsEventConst.FORM_ID: !(_eventModel == null)
              ? "edit_event_itinerary"
              : "add_new_event_itinerary",
        });
  }

  /// Fetches location suggestions from Google Places API
  Future<void> fetchSuggestions(String location) async {
    isLoading = true;

    try {
      final response = await _fetchPlaceData(location);
      await _processPlaceResponse(location, response);
    } catch (e) {
      _handleFetchError(e);
    }
  }

  void addToFormError(Map<String, dynamic> error) {
    bool exists = formError.any((map) =>
        map.length == error.length &&
        map.entries.every((entry) => error[entry.key] == entry.value));
    if (!exists) {
      formError.add(error);
    }
  }

  /// Fetches place data from Google Places API
  Future<dynamic> _fetchPlaceData(String location) async {
    return await apiClient.get(
      endpoint: "",
      isDataNodePresent: false,
      fromJson: PlaceResponse.fromJson,
      addAuthHeader: false,
      customUrl: _buildPlacesApiUrl(location),
    );
  }

  /// Builds the Google Places API URL
  String _buildPlacesApiUrl(String location) {
    return "https://maps.googleapis.com/maps/api/place/textsearch/json"
        "?query=${location.trim()}"
        "&region=us"
        "&language=$languageCode"
        "&key=${EnvConfig.googlePlacesApiKey}";
  }

  /// Processes the place response
  Future<void> _processPlaceResponse(String location, dynamic response) async {
    if (!_isValidPlaceResponse(response)) return;

    final firstResult = response.data!.results!.first;
    final locationData = firstResult.geometry!.location!;

    placePredictions = response.data;
    await getTimeOffset(location, locationData);

    event_longitude = locationData.lng;
    event_latitude = locationData.lat;

    _finishFetching();
  }

  /// Checks if the place response is valid
  bool _isValidPlaceResponse(dynamic response) {
    return response.data != null &&
        response.isSuccess &&
        response.data!.results != null &&
        response.data!.results!.isNotEmpty;
  }

  /// Handles fetch errors
  void _handleFetchError(dynamic error) {
    isLoading = false;
    Utils.logPrint("Error: $error");
  }

  /// Finishes the fetching process
  void _finishFetching() {
    isLoading = false;
    setState();
  }

  /// Gets timezone offset for a location
  Future<void> getTimeOffset(String location, Location searchLocation) async {
    try {
      final timeOffsetResponse = await _fetchTimezoneData(searchLocation);
      await _processTimezoneResponse(location, timeOffsetResponse);
    } catch (e) {
      _handleTimezoneError(e);
    }
  }

  /// Fetches timezone data from Google Timezone API
  Future<dynamic> _fetchTimezoneData(Location searchLocation) async {
    return await apiClient.get(
      endpoint: "",
      isDataNodePresent: false,
      fromJson: TimeZoneInfo.fromJson,
      addAuthHeader: false,
      customUrl: _buildTimezoneApiUrl(searchLocation),
    );
  }

  /// Builds the Google Timezone API URL
  String _buildTimezoneApiUrl(Location searchLocation) {
    final timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    return "https://maps.googleapis.com/maps/api/timezone/json"
        "?location=${searchLocation.lat},${searchLocation.lng}"
        "&timestamp=$timestamp"
        "&key=${EnvConfig.googlePlacesApiKey}";
  }

  /// Processes the timezone response
  Future<void> _processTimezoneResponse(
      String location, dynamic response) async {
    if (!_isValidTimezoneResponse(response)) return;

    final timezoneData = response.data!;
    final totalOffset =
        (timezoneData.rawOffset ?? 0) + (timezoneData.dstOffset ?? 0);

    timezoneOffset = DateUtil.getFormattedOffset(totalOffset);
    locationEdt.text = location;
    event_dst_offset = DateUtil.getFormattedOffset(totalOffset);
    event_raw_offset = timezoneData.rawOffset ?? 0;
  }

  /// Checks if the timezone response is valid
  bool _isValidTimezoneResponse(dynamic response) {
    return response.isSuccess &&
        response.data != null &&
        response.data!.status != null &&
        response.data!.status == AppConst.OK;
  }

  /// Handles timezone fetch errors
  void _handleTimezoneError(dynamic error) {
    isLoading = false;
    Utils.logPrint("Error: $error");
  }

  /// Shows error state
  void onShowError() {
    showError = true;
    setState();
  }

  /// Handles valid state changes
  void validStateChanges(String valid) {
    updateEditState();
    _removeValidationError(valid);
    _clearErrorMessages();
    _showValidationErrors();
    checkDisable();
    setState();
  }

  /// Removes validation error from the list
  void _removeValidationError(String valid) {
    if (formValid.contains(valid)) {
      formValid.remove(valid);
    }
  }

  /// Clears error messages
  void _clearErrorMessages() {
    errorText = null;
    errorTextStart = null;
  }

  /// Shows validation errors
  void _showValidationErrors() {
    showError = true;
    formError.clear();
  }

  /// Validates a specific field
  void validate(String valid, bool val) {
    _addValidationError(valid);
    _formError(val);
    setState();
    _scheduleFormValidation();
  }

  /// Adds validation error to the list
  void _addValidationError(String valid) {
    if (!formValid.contains(valid)) {
      formValid.add(valid);
    }
  }

  /// Schedules form validation
  void _scheduleFormValidation() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (showError && formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  /// Checks for general errors
  void checkError(String error) {
    _resetValidationState();
    _setErrorText(error);
    setState();
    _scheduleFormValidation();
  }

  /// Resets validation state
  void _resetValidationState() {
    formValid = [];
    showError = true;
  }

  /// Sets error text
  void _setErrorText(String error) {
    errorText = error;
  }

  /// Checks for start time errors
  void checkErrorStart(String error) {
    errorTextStart = error;
    setState();
    validate(S.of(getContext()).start, _eventModel == null);
    Utils.announceMessage(error);
  }

  /// Checks if the form should be disabled
  void checkDisable() {
    isDisable = !_isFormValid();
    setState();
  }

  /// Checks if the form is valid
  bool _isFormValid() {
    return _hasValidEventName() &&
        _hasValidDateAndStart() &&
        _hasValidLocation() &&
        _hasSelectedCategory();
  }

  /// Checks if event name is valid
  bool _hasValidEventName() {
    return eventName.text.length > 1;
  }

  /// Checks if date and start time are valid
  bool _hasValidDateAndStart() {
    return date.text.length > 1 && start.text.length > 1;
  }

  /// Checks if location is valid
  bool _hasValidLocation() {
    return locationEdt.text.length > 1;
  }

  /// Checks if a category is selected
  bool _hasSelectedCategory() {
    return categoryList.any((category) => category.isSelected == true);
  }

  /// Changes the selected category
  void changeCategoryList(int index) {
    _deselectAllCategories();
    _selectCategoryIfNotSelected(index);
    checkDisable();
    setState();
  }

  /// Deselects all categories
  void _deselectAllCategories() {
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList.elementAt(i).isSelected == true) {
        categoryList.elementAt(i).isSelected = false;
      }
    }
  }

  /// Selects a category if it's not already selected
  void _selectCategoryIfNotSelected(int index) {
    if (categoryList.elementAt(index).isSelected == false) {
      categoryList.elementAt(index).isSelected = true;
      showCategoryError = false;
      _announceCategorySelection(index);
      setState();
    }
  }

  /// Announces category selection for accessibility
  void _announceCategorySelection(int index) {
    final selectedLabel = categoryList[index].optionName?.trim() ?? "";
    Utils.announceMessage("$selectedLabel, ${S.of(getContext()).selected}");
  }

  /// Picks a date for the event
  Future<void> pickDate() async {
    FocusScope.of(getContext()).unfocus();
    final context = getContext();
    final selectedDate = await Utils.pickDate(
      context,
      calendarDateTime ?? DateTime.now(),
    );

    if (selectedDate != null) {
      _updateSelectedDate(selectedDate);
      validStateChanges(S.of(context).date);
    }
  }

  /// Updates the selected date
  void _updateSelectedDate(DateTime selectedDate) {
    calendarDateTime = selectedDate;
    date.text = DateUtil.formatFull(getContext(), selectedDate);
    setState();
  }

  /*
    pickTime(bool isStart) async {
    FocusScope.of(getContext()).unfocus();

    //Ayush implement starttime end time logic.
    TimeOfDay? datetime = await Utils.pickTime(
        getContext(), isStart ? startTime : endTime, is24hrsClockEnable);
    if (datetime != null) {
      if (isStart == true) {
        start.text =
            "${datetime.hour.toString().padLeft(2, "0")}:${datetime.minute.toString().padLeft(2, "0")}";
        startTime = datetime;
      } else {
        end.text =
            "${datetime.hour.toString().padLeft(2, "0")}:${datetime.minute.toString().padLeft(2, "0")}";
        endTime = datetime;
      }
      setState();
      if (isStart) {
        validStateChanges(S.of(getContext()).start);
      }
    }
  }
   */

  /// Picks a time for the event
  Future<void> pickTime(bool isStart) async {
    _logTimePickAnalytics();
    FocusScope.of(getContext()).unfocus();

    final context = getContext();
    final pickedTime = await Utils.pickTime(
      context,
      isStart ? startTime : endTime,
      is24hrsClockEnable,
    );

    if (pickedTime != null) {
      _updateSelectedTime(isStart, pickedTime);
      _handleTimeValidation(isStart);
      if (!isStart) {
        updateEditState();
      }
    }
  }

  /// Logs analytics for time picking
  void _logTimePickAnalytics() {
    if (_eventModel != null) {
      FirebaseAnalyticsService.logEvent(
        eventName: "itineraryCreation_editEvent_formstart",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
              "add_to_itinerary",
          AnalyticsEventConst.PARAM_NAME_FORM_NAME: "edit_event_itinerary",
          AnalyticsEventConst.PARAM_NAME_FORM_ID: "edit_event_itinerary",
        },
      );
    }
  }

  /// Updates the selected time
  void _updateSelectedTime(bool isStart, TimeOfDay pickedTime) {
    if (isStart) {
      start.text = getTimeFRomTimePciker(pickedTime, is24hrsClockEnable);
      startTime = pickedTime;
      Utils.logPrint("startTime pick $startTime");
    } else {
      end.text = getTimeFRomTimePciker(pickedTime, is24hrsClockEnable);
      endTime = pickedTime;
    }
    setState();
  }

  /// Handles time validation
  void _handleTimeValidation(bool isStart) {
    if (isStart) {
      validStateChanges(S.of(getContext()).start);
    }

    if (start.text.isNotEmpty && end.text.isNotEmpty) {
      _validateStartEndTimes();
    }
  }

  /// Validates start and end times
  void _validateStartEndTimes() {
    final isStartAfterEnd =
        DateUtil.isStartTimeAfterEndTime(startTime!, endTime!);

    if (isStartAfterEnd) {
      checkErrorStart(S.of(getContext()).start_time_occurs);
    } else {
      errorTextStart = null;
      validate(S.of(getContext()).start, _eventModel == null);
      setState();
    }
  }

  // void _showCupertinoDatePicker(BuildContext context, {required bool isStart}) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext builder) {
  //       return SizedBox(
  //         height: 250,
  //         child: CupertinoDatePicker(
  //           mode: CupertinoDatePickerMode.time,
  //           initialDateTime: DateTime.now(),
  //           onDateTimeChanged: (DateTime datetime) {
  //             if (isStart == true) {
  //               start.text = datetime.hour.toString().padLeft(2, "0") +
  //                   ":" +
  //                   datetime.minute.toString().padLeft(2, "0");
  //             } else {
  //               end.text = datetime.hour.toString().padLeft(2, "0") +
  //                   ":" +
  //                   datetime.minute.toString().padLeft(2, "0");
  //             }
  //             setState();
  //             if (isStart) {
  //               validStateChanges(S.of(getContext()).start);
  //             }
  //             if (start.text.isNotEmpty && end.text.isNotEmpty) {
  //               bool rep = DateUtil.isStartTimeAfterEndTime(
  //                   start.text.trim(), end.text.trim());
  //               if (rep == true) {
  //                 checkErrorStart(S.of(getContext()).start_time_occurs);
  //               } else {
  //                 errorTextStart = null;
  //                 validate(S.of(getContext()).start);
  //                 setState();
  //               }
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  /// Handles the add/edit itinerary button action
  Future<void> addItineraryButton(bool isForUpdate) async {
    await _initializeValidation();
    await Future.delayed(const Duration(milliseconds: 150));

    if (!_validateFormData()) return;
    if (!_validateCategorySelection()) return;
    if (!_validateFormFields()) {
      _formError(isForUpdate);
      return;
    }
    if (!_validateCategoryError()) return;
    if (!_validateStartTime()) return;
    if (isForUpdate) {
      _showNoChangesInEventMessage();
      return;
    }
    await _processItinerarySubmission(isForUpdate);
  }

  /// Initializes validation state
  Future<void> _initializeValidation() async {
    formValid = [
      S.of(getContext()).event_name,
      S.of(getContext()).date,
      S.of(getContext()).start,
      S.of(getContext()).location,
    ];

    showError = true;
    errorText = null;
    errorTextStart = null;
    setState();
  }

  /// Validates form data
  bool _validateFormData() {
    if (endTime != null) {
      final isStartAfterEnd =
          DateUtil.isStartTimeAfterEndTime(startTime!, endTime!);
      if (isStartAfterEnd) {
        checkErrorStart(S.of(getContext()).start_time_occurs);
        return false;
      }
    }
    return true;
  }

  /// Validates category selection
  bool _validateCategorySelection() {
    final selectedCategories =
        categoryList.where((event) => event.isSelected == true).toList();
    if (selectedCategories.isEmpty) {
      showCategoryError = true;
      addToFormError({
        "label": "category",
        "error": S.of(getContext()).category_is_required
      });
      Utils.announceMessage(S.of(getContext()).category_is_required);
      setState();
    }
    return true;
  }

  /// Validates form fields
  bool _validateFormFields() {
    return formKey.currentState != null && formKey.currentState!.validate();
  }

  /// Form error
  void _formError(bool isForUpdate) {
    Future.delayed(const Duration(milliseconds: 350), () {
      String errorField = formError
          .map((map) => map['label'])
          .where((name) => name != null)
          .join(', ');
      String errorMessage = formError
          .map((map) => map['error'])
          .where((name) => name != null)
          .join(', ');
      FirebaseAnalyticsService.logEvent(
        eventName: !isForUpdate
            ? "itineraryCreation_editEvent_formerror"
            : "itineraryCreation_addNewEvent_formerror",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
              !isForUpdate ? "edit_to_itinerary" : "add_to_itinerary",
          AnalyticsEventConst.FORM_NAME:
              !isForUpdate ? "edit_event_itinerary" : "add_new_event_itinerary",
          AnalyticsEventConst.FORM_ID:
              !isForUpdate ? "edit_event_itinerary" : "add_new_event_itinerary",
          "error_field": errorField,
          "error_type": errorMessage,
          "error_message": errorMessage,
        },
      );
      Utils.logPrint("Errors: $formError");
    });
  }

  /// Validates category error
  bool _validateCategoryError() {
    if (showCategoryError) {
      showCategoryError = true;
      Utils.announceMessage(S.of(getContext()).category_is_required);
      scrollToCategoryError();
      return false;
    }
    return true;
  }

  /// Validates start time
  bool _validateStartTime() {
    if (startTime == null) return true;

    final now = calendarDateTime ?? DateTime.now();
    final pickedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime!.hour,
      startTime!.minute,
    );

    if (pickedDateTime.isBefore(DateTime.now())) {
      checkErrorStart(S.of(getContext()).past_time);
      return false;
    }
    return true;
  }

  /// Processes the itinerary submission
  Future<void> _processItinerarySubmission(bool isForUpdate) async {
    isLoading = true;

    try {
      final model = _createEventModel();

      // Utils.logPrint("_processItinerarySubmission ${model.toJson()}  ");

      // isLoading = false;

      // return;

      if (_eventModel == null) {
        await _handleAddEvent(model);
      } else {
        await _handleUpdateEvent(model, isForUpdate);
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
    }
  }

  /// Creates the event model
  EventModel _createEventModel() {
    final selectedCategories =
        categoryList.where((event) => event.isSelected == true).toList();

    return EventModel(
      eventCategory: selectedCategories.first.optionId,
      eventDate: DateUtil.formatGetWithFormat(
        mContext,
        calendarDateTime!,
        addLocalisation: false,
        DateUtil.DATE_FORMAT_YYYY_MM_DD,
      ),
      eventDescription: description.text.isEmpty ? "" : description.text,
      eventEndTime: endTime != null
          ? getTimeFRomTimePciker(endTime!, true, addLocalisation: false) +
              timezoneOffset
          : "",
      eventStartTime:
          getTimeFRomTimePciker(startTime!, true, addLocalisation: false) +
              timezoneOffset,
      eventLocation: locationEdt.text,
      eventTitle: eventName.text,
      eventType: "",
      eventLatitude: event_latitude,
      eventLongitude: event_longitude,
      eventRawOffset: event_raw_offset,
    );
  }

  /// Handles adding a new event
  Future<void> _handleAddEvent(EventModel model) async {
    final response =
        await _itineraryRepo!.addEvent((json) => (), model.toJson());
    if (response.data != null && response.isSuccess) {
      await _handleSuccessfulAdd();
      isLoading = false;
      setState();
    } else {
      isLoading = false;
      setState();
      _handleFailedAdd(response);
    }
  }

  /// Handles successful add operation
  Future<void> _handleSuccessfulAdd() async {
    _logAddEventAnalytics();
    _showSuccessMessage();
    await _handleRateUsFlow();
    // the calendar should automatically scroll to the nearest upcoming event
    // Auto-scroll to the newly added event
    if (calendarDateTime != null) {
      final eventDate = DateUtil.formatGetWithFormat(
        mContext,
        calendarDateTime!,
        DateUtil.DATE_FORMAT_YYYY_MM_DD,
      );
      itineraryProvider?.onEventAdded(eventDate);
    }

    _navigateBack(true);
  }

  /// Logs add event analytics
  void _logAddEventAnalytics() {
    final selectedCategories =
        categoryList.where((event) => event.isSelected == true).toList();

    FirebaseAnalyticsService.logEvent(
      eventName: !(_eventModel == null)
          ? "itineraryCreation.editEvent.formcomplete"
          : "itineraryCreation.addNewEvent.formcomplete",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
            !(_eventModel == null) ? "editToItinerary" : "addToItinerary",
        AnalyticsEventConst.FORM_NAME: !(_eventModel == null)
            ? "edit_new_event_itinerary"
            : "add_new_event_itinerary",
        AnalyticsEventConst.FORM_ID: !(_eventModel == null)
            ? "edit_new_event_itinerary"
            : "add_new_event_itinerary",
        "selected_preferences": selectedCategories.first.optionId ?? ""
      },
    );
  }

  /// Shows success message
  void _showSuccessMessage() {
    visaSnackBar(
      context: getContext(),
      title: "${S.of(getContext()).success}!",
      subtitle: S.of(getContext()).add_itinerary_success,
      showAtBottom: false,
    );
  }

  /// Handles rate us flow
  Future<void> _handleRateUsFlow() async {
    final rateUs = await Preferences.getBool(Preferences.isRateUs);
    if (rateUs == false) {
      _userDetailRepo = UserDetailRepo(apiClient);
      await Preferences.setBool(Preferences.isRateUs, true);

      Future.delayed(const Duration(milliseconds: 2800), () {
        Utils.rateUsPopup(
          context: AmplifyService.context!,
          child: const RateUsPopup(),
        );

        userDetailRepo?.updateUserPreferenceKnowYourUser({
          "rate_us": ["true"]
        }, (json) => (), false);
      });
    }
  }

  /// Handles failed add operation
  void _handleFailedAdd(dynamic response) {
    visaSnackBar(
      context: getContext(),
      type: SnackBarType.failure,
      title: "${S.of(getContext()).error}!",
      subtitle: response != null
          ? Utils.getErrorMessageFromString(response.messageKey ?? "")
          : S.of(getContext()).something_went_wrong,
      showAtBottom: false,
    );
  }

  /// Handles updating an existing event
  Future<void> _handleUpdateEvent(EventModel model, bool isForUpdate) async {
    final response = await _itineraryRepo!.patchEvent(
      (json) => (),
      model.toJson(),
      _eventModel!.eventId!,
    );

    Utils.logPrint("data ${response.messageKey}");

    if (response.data != null && response.isSuccess) {
      await _handleSuccessfulUpdate();
    } else {
      _handleFailedUpdate(response);
    }
  }

  /// Handles successful update operation
  Future<void> _handleSuccessfulUpdate() async {
    _logUpdateEventAnalytics();
    _showUpdateSuccessMessage();
    _navigateBack(false);
    _navigateBack(true); // Double pop for edit flow
  }

  /// Logs update event analytics
  void _logUpdateEventAnalytics() {
    final selectedCategories =
        categoryList.where((event) => event.isSelected == true).toList();

    FirebaseAnalyticsService.logEvent(
      eventName: "itineraryCreation_editEvent_formcomplete",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "update",
        AnalyticsEventConst.PARAM_NAME_FORM_NAME: "edit_event_itinerary",
        AnalyticsEventConst.PARAM_NAME_FORM_ID: "edit_event_itinerary",
        "select_prefences": selectedCategories.first.optionId ?? ""
      },
    );
  }

  /// Shows update success message
  void _showUpdateSuccessMessage() {
    visaSnackBar(
      context: getContext(),
      title: "${S.of(getContext()).success}!",
      subtitle: S.of(getContext()).edit_itinerary_success,
      showAtBottom: false,
    );
  }

  /// Handles failed update operation
  void _handleFailedUpdate(dynamic response) {
    visaSnackBar(
      context: getContext(),
      type: SnackBarType.failure,
      title: "${S.of(getContext()).error}!",
      subtitle: response != null
          ? Utils.getErrorMessageFromString(
              response.messageKey ?? S.of(getContext()).something_went_wrong)
          : S.of(getContext()).something_went_wrong,
      showAtBottom: false,
    );
  }

  /// Navigates back and refreshes itinerary
  void _navigateBack(bool refreshItinerary) {
    navPop();
    if (refreshItinerary) {
      fetchItineraryDetail();
    }
  }

  patchEvent() async {
    try {} catch (e) {}
  }

  goToLocationScreen() async {
    FocusScope.of(getContext()).unfocus();
    FirebaseAnalyticsService.logEvent(
        eventName: "itineraryCreation_locationSearch",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
              AppRoutes.addItineraryLocation,
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
              AppRoutes.addItineraryLocation,
        });
    final rep = await navPush(AppRoutes.addItineraryLocation,
        extra: locationEdt.text.trim());
    if (rep != null) {
      Utils.logPrint("rep ${rep}");
      locationEdt.text = rep["search"];
      timezoneOffset = rep["timezoneOffset"];

      // Utils.logPrint("location ${rep["location"].toJson()}");

      Location location = rep["location"] as Location;
      TimeZoneInfo timeZoneInfo = rep["timeOffsetData"] as TimeZoneInfo;

      event_longitude = location!.lng;
      event_latitude = location!.lat;
      event_time_zone_id = timeZoneInfo.timeZoneId;
      event_time_zone = timeZoneInfo.timeZoneName;
      event_dst_offset = timezoneOffset;
      event_raw_offset = timeZoneInfo.rawOffset;

      setState();
      validStateChanges(S.of(getContext()).location);
      checkDisable();
    }
  }

  void deleteEvent(BuildContext context) async {
    FirebaseAnalyticsService.logEvent(
        eventName: "itineraryCreation_editEvent_delete",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "edit_event",
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "delete",
        });
    var isConfirmClick = await context.showDeleteEventDialog(
      context: context,
      title: S.of(context).are_you_sure,
      description: S.of(context).delete_event_can_not_undone,
      backgroundColor: VisaColors.white,
      barrierDismissible: false,
      buttonText: S.of(context).delete,
      buttonBgColor: VisaColors.red,
    );
    if (isConfirmClick != null && isConfirmClick) {
      Utils.removeFocus();
      isLoading = true;
      final rep = await itineraryRepo!
          .deleteEvent((json) => (), _eventModel?.eventId ?? "");

      if (rep != null && rep.isSuccess) {
        // itinerary_deleted_success
        isLoading = false;

        visaSnackBar(
            context: getContext(),
            title: S.of(getContext()).success,
            type: SnackBarType.success,
            subtitle: S.of(getContext()).itinerary_deleted_success,
            showAtBottom: true);
        navPop();
        navPop();
        fetchItineraryDetail();
      } else {
        isLoading = false;
        visaSnackBar(
            context: getContext(),
            title: S.of(getContext()).error,
            type: SnackBarType.failure,
            subtitle: S.of(getContext()).try_again,
            showAtBottom: true);
      }
    }
  }

  String getTimeFRomTimePciker(TimeOfDay pickedTime, bool is24hrsClockEnable,
      {bool addLocalisation = true}) {
    final now = DateTime.now();
    final datetime = DateTime(
        now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);

    return DateFormat(
            is24hrsClockEnable ? _timeFormat24Hour : _timeFormat12Hour,
            addLocalisation
                ? Localizations.localeOf(mContext).languageCode
                : "en")
        .format(datetime);
  }

  void fetchItineraryDetail() {
    // the calendar should automatically scroll to the nearest upcoming event
    // If this is a new event (not editing), auto-scroll to the event date
    if (_eventModel == null && calendarDateTime != null) {
      final eventDate = DateUtil.formatGetWithFormat(
          mContext, calendarDateTime!, DateUtil.DATE_FORMAT_YYYY_MM_DD,
          addLocalisation: false);
      itineraryProvider?.onEventAdded(eventDate);
      itineraryProvider?.fetchItineary();
    } else {
      // For editing existing events, just refresh the itinerary
      itineraryProvider?.focusedDay = calendarDateTime ?? DateTime.now();
      itineraryProvider?.selectedDay = calendarDateTime ?? DateTime.now();
      itineraryProvider?.fetchItineary();
    }
  }

  void scrollToCategoryError() {
    if (addItineraryController.hasClients) {
      addItineraryController.animateTo(
        addItineraryController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  updateEditState() {
    isUpdate = true;
    setState();
  }

  void _showNoChangesInEventMessage() {
    visaSnackBar(
      context: getContext(),
      title: "${S.of(getContext()).no_changes_detected}!",
      subtitle: S.of(getContext()).no_change_in_event,
      showAtBottom: false,
      type: SnackBarType.failure,
    );
  }
}
