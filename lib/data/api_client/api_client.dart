
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../core/exceptions.dart';
import '../../core/servers.dart';

class ApiClient {
  static RemoteServer? _server;
  static final Dio _dio = Dio();

  init({required RemoteServer server}) {
    _server = server;
    _dio.interceptors.add(
      PrettyDioLogger(
        responseBody: true,
        requestBody: true,
      ),
    );
    _dio.options = BaseOptions(
        baseUrl: '${_server!.scheme}://${_server!.url}',
        connectTimeout: Duration(milliseconds: _server!.timeOut));
  }

  Future<dynamic> makeNetworkCall({
    required String method,
    required String path,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  }) async {
    try {
      late Response response;
      if (_server != null) {
        //log url and body
        //FormData formData = FormData.fromMap(body ?? {});
        var httpMethod = path + (method.toLowerCase() == "get" ? "" : "/");
        response = await _dio.request(
          httpMethod,
          queryParameters: params,
          data: body,
          options: Options(method: method),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data;
        }
      } else {
        throw const ServerException("Remote Server is not defined.");
      }
    } on DioError catch (err) {
      String errorMessage =
          err.response?.data["error"]?.toString() ?? "Something went wrong.";
      switch (err.type) {
        case DioErrorType.connectionTimeout:
          throw BadRequestException(errorMessage);
        case DioErrorType.badResponse:
          throw BadRequestException(errorMessage);
        case DioErrorType.connectionError:
          throw const NetworkConnectionException("No Internet Connection.");
        default: //DioErrorType.DEFAULT:
          throw const UnDefinedException("No Internet Connection.");
      }
    }
  }
}
