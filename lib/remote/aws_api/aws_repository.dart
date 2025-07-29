import 'package:visaamigo/remote/aws_api/aws_api_model.dart';

import 'aws_api_response.dart';
import 'aws_api_service.dart';

class AwsRepository<T> {
  final AwsApiService _apiService;
  final AwsApiModel<T> _model;

  AwsRepository({
    required AwsApiService apiService,
    required AwsApiModel<T> model,
  })  : _apiService = apiService,
        _model = model;

  Future<AwsApiResponse<T>> getById(String id) {
    return _apiService.get<T>(
      endpoint: '${_model.endpoint}/$id',
      parser: _model.parser,
    );
  }

  Future<AwsApiResponse<T>> create(Map<String, dynamic> data) {
    return _apiService.post<T>(
      endpoint: _model.endpoint,
      body: data,
      parser: _model.parser,
    );
  }

  Future<AwsApiResponse<T>> update(String id, Map<String, dynamic> data) {
    return _apiService.put<T>(
      endpoint: '${_model.endpoint}/$id',
      body: data,
      parser: _model.parser,
    );
  }

  Future<AwsApiResponse<T>> delete(String id) {
    return _apiService.delete<T>(
      endpoint: '${_model.endpoint}/$id',
      parser: _model.parser,
    );
  }
}
