import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../custom_widgets/loader/loading_provider.dart';
import '../../remote/api_client.dart';
import '../../remote/api_response.dart';
import '../../remote/paginate_response.dart';
import '../../utils/amplify_service.dart';
import '../../utils/responsive_util.dart';
import '../../utils/utils.dart';
import 'base_loading_state.dart';

class BaseProvider<T> extends ChangeNotifier implements LoadingState {
  final ApiClient apiClient = ApiClient();
  Map<String, ApiResponse<T>> _responses = {};
  bool _isLoadingMore = false;

  set isLoadingMore(bool value) {
    _isLoadingMore = value;
  }

  BuildContext? _mContext;

  BuildContext get mContext => _mContext ?? AmplifyService.context!;

  set mContext(BuildContext value) {
    _mContext = value;
  }

  AmplifyService amplifyService = AmplifyService();

  //Navigation Push
  navPush(String name, {Object? extra}) {
    //mContext.pushRoute(name, extra: extra);
    return AppRouter.router.pushRoute(name, extra: extra);
  }

  //Navigation Push
  navPushReplace(String name, {Object? extra}) {
    //mContext.pushRoute(name, extra: extra);
    return AppRouter.router.pushReplacement(name, extra: extra);
  }

  //Navigation Go
  navGo(String name, {Object? extra}) {
    // mContext.goRoute(name, extra: extra);
    AppRouter.router.goRoute(name, extra: extra);
  }

  //Navigation Pop
  navPop() {
    //mContext.pop();
    if (AppRouter.router.canGoBack) {
      AppRouter.router.popRoute();
    }
  }

  getContext() {
    return mContext;
  }

  T? _selectedItem;

  void setState() {
    if (mContext.mounted) {
      notifyListeners();
    }
  }

  void setContext(BuildContext context) async {
    mContext = context;
  }

  BaseProvider();

  ApiResponse<T> getResponse(String key) => _responses[key] ?? ApiResponse<T>();

  bool get isLoadingMore => _isLoadingMore;

  T? get selectedItem => _selectedItem;

  void _updateResponse(String key, ApiResponse<T> response) {
    _responses[key] = response;
    setState();
  }

  void clearPagination() {
    _responses = {};
  }

  void setSelectedItem(T? item) {
    _selectedItem = item;
    setState();
  }

  bool get isDesktopView {
    return mContext.mounted &&
        GetIt.I<ResponsiveUtil>(param1: mContext).isDesktop(context: mContext);
  }

  bool get isMobileWebView {
    return mContext.mounted &&
        GetIt.I<ResponsiveUtil>(param1: mContext)
            .isMobileWeb(context: mContext);
  }

  bool get isTabletView {
    return mContext.mounted &&
        GetIt.I<ResponsiveUtil>(param1: mContext).isTablet(context: mContext);
  }

  bool get isTabletWebFromBase {
    return mContext.mounted &&
        GetIt.I<ResponsiveUtil>(param1: mContext).isTablet(context: mContext);
  }

  Future<ApiResponse<T>> getData({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    required String responseKey,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool isPaginated = false,
    bool isDataNodePresent = true,
    bool showLoader = true,
  }) async {
    _updateResponse(
        responseKey, getResponse(responseKey).copyWith(isLoading: true));

    isLoading = showLoader;

    final apiResponse = await apiClient.get(
      endpoint: endpoint,
      fromJson: fromJson,
      headers: headers,
      queryParameters: queryParameters,
      isPaginated: isPaginated,
    );

    _updateResponse(responseKey, apiResponse);
    isLoading = false;
    return apiResponse;
  }

/*  Future<ApiResponse<T>> postData({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    required String responseKey,
    required dynamic body,
    Map<String, String>? headers,
    bool isPaginated = false,
    bool isDataNodePresent = true,
    bool showLoader = true,
    bool addAuthHeader = true,
  }) async {
    _updateResponse(
        responseKey, getResponse(responseKey).copyWith(isLoading: true));

    isLoading = showLoader;

    final apiResponse = await apiClient.post(
      endpoint: endpoint,
      body: body,
      fromJson: fromJson,
      headers: headers,
      isPaginated: isPaginated,
    );

    _updateResponse(responseKey, apiResponse);
    isLoading = false;
    return apiResponse;
}*/

  Future<ApiResponse<T>?> loadMore({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    required String responseKey,
    required String itemsKey,
    required int nextPage,
    int dataLimit = 6,
    Map<String, String>? headers,
  }) async {
    // if (_isLoadingMore) return null;

    final currentResponse = getResponse(responseKey);
    // if (currentResponse.paginatedData == null ||
    //     !currentResponse.paginatedData!.hasNextPage) {
    //   return;
    // }

    _isLoadingMore = true;
    setState();

    try {
      final apiResponse = await apiClient.get(
          endpoint: endpoint,
          fromJson: fromJson,
          headers: headers,
          queryParameters: {
            'page_no': nextPage.toString(),
            'limit': dataLimit.toString()
          },
          isPaginated: true,
          itemsKey: itemsKey,
          isDataNodePresent: true,
          isJsonRequired: true);

      // return apiResponse;

      if (apiResponse.paginatedData != null) {
        var updatedItems = [
          // ...currentResponse.paginatedData!.items,
          ...apiResponse.paginatedData!.items,
        ];

        if (currentResponse.paginatedData != null) {
          updatedItems.addAll(currentResponse.paginatedData!.items);
        }

        Utils.logPrint(
            "apiResponse currentPage  ${apiResponse.paginatedData!.currentPage}");

        final updatedPaginatedResponse = PaginatedResponse<T>(
          items: updatedItems,
          currentPage: apiResponse.paginatedData!.currentPage,
          totalPages: apiResponse.paginatedData!.totalPages,
          totalItems: apiResponse.paginatedData!.totalItems,
          hasNextPage: apiResponse.paginatedData!.hasNextPage,
        );

        _updateResponse(
          responseKey,
          ApiResponse<T>(paginatedData: updatedPaginatedResponse),
        );

        return apiResponse;
      }
    } catch (e) {
      Utils.logPrint("exception ${e.toString()}");
    }
  }

  bool _isLoading = false;

  @override
  bool get isLoading => _isLoading;

  @override
  set isLoading(bool value) {
    _isLoading = value;

    try {
      if (mContext.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mContext.read<LoadingProvider>().setLoad(_isLoading);
          notifyListeners();
        });
      }
    } catch (e) {
      Utils.logPrint("isLoading catch ${e} ");
    }
  }
}
