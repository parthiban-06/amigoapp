import '../../../remote/api_client.dart';
import '../../../remote/api_response.dart';
import '../../../utils/app_const.dart';

class ItineraryRepo {
  final ApiClient apiClient;

  ItineraryRepo(this.apiClient);

  Future<ApiResponse<T>> addEvent<T>(
      T Function(Map<String, dynamic> json) fromJson, dynamic body) async {
    return await apiClient.post(
        endpoint: AppConst.EVENT,
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> patchEvent<T>(
      T Function(Map<String, dynamic> json) fromJson,
      dynamic body,
      String id) async {
    return await apiClient.patch(
        endpoint: "${AppConst.EVENT}/$id",
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getUsersEvent<T>(
      T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.get(
        endpoint: AppConst.EVENT_ITINERARIES,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> deleteEvent<T>(
      T Function(Map<String, dynamic> json) fromJson, String id) async {
    return await apiClient.delete(
        endpoint: "${AppConst.EVENT}/$id",
        fromJson: fromJson,
        isDataNodePresent: false);
  }
}
