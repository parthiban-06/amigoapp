import 'aws_api_response.dart';

class AwsApiModel<T> {
  final String endpoint;
  final JsonParser<T> parser;

  AwsApiModel({
    required this.endpoint,
    required this.parser,
  });
}
