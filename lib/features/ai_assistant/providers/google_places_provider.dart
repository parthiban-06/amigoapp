// Provider for Google Places Autocomplete
import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../../core/config/env_config.dart';
import '../../../remote/api_client.dart';
import '../models/ai_assistance_place_api.dart';

class GooglePlacesProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final BuildContext mContext;
  final String languageCode;
  final ApiClient apiClient; // Replace with your API client

  bool _isLoading = false;
  bool _showClearButton = false;
  Timer? _debounce;
  List<Prediction> _predictions = [];
  String _selectedPlaceId = '';
  String _selectedPlaceName = '';

  GooglePlacesProvider({
    required this.mContext,
    this.languageCode = 'en',
    required this.apiClient,
  }) {
    // Add listeners
    focusNode.addListener(_onFocusChange);
    searchController.addListener(_onTextChange);
  }

  // Getters
  bool get isLoading => _isLoading;

  bool get showClearButton => _showClearButton;

  List<Prediction> get predictions => _predictions;

  String get selectedPlaceId => _selectedPlaceId;

  String get selectedPlaceName => _selectedPlaceName;

  void _onFocusChange() {
    _showClearButton = searchController.text.isNotEmpty && focusNode.hasFocus;
    notifyListeners();

    if (focusNode.hasFocus && searchController.text.isNotEmpty) {
      getPredictions(searchController.text);
    }
  }

  void _onTextChange() {
    _showClearButton = searchController.text.isNotEmpty && focusNode.hasFocus;
    notifyListeners();

    if (searchController.text.isNotEmpty) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        getPredictions(searchController.text);
      });
    } else {
      _predictions = [];
      notifyListeners();
    }
  }

  Future<void> getPredictions(String input) async {
    if (input.isEmpty) {
      _predictions = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final rep = await apiClient.get(
        endpoint: "",
        isDataNodePresent: false,
        fromJson: PlacePredictions.fromMap,
        addAuthHeader: false,
        customUrl:
            "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${input.trim()}&types=(cities)&language=$languageCode&key=${EnvConfig.googlePlacesApiKey}",
      );

      _isLoading = false;

      if (rep.isSuccess && rep.data != null) {
        _predictions = rep.data?.predictions ?? [];
      }

      notifyListeners();

      // Maintain focus - check if context is still mounted
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mContext.mounted) {
          FocusScope.of(mContext).requestFocus(focusNode);
        }
      });
    } catch (e) {
      _isLoading = false;
      _predictions = [];
      notifyListeners();
    }
  }

  void selectPlace(String placeId, String placeName) {
    _selectedPlaceId = placeId;
    _selectedPlaceName = placeName;
    searchController.text = placeName;
    _predictions = [];
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    _predictions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    focusNode.removeListener(_onFocusChange);
    searchController.removeListener(_onTextChange);
    focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }
}
