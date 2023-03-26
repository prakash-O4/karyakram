import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../core/exceptions.dart';
import '../../di/injector.dart';
import '../api_client/api_client.dart';

class AppRepository {
  /// [This repo connects between the network call and the bloc layer]
  Future<Either<AppException, dynamic>> repoHandler(
      {required String path,
      required String method,
      Map<String, dynamic>? params,
      Map<String, dynamic>? body}) async {
    try {
      var response = await sl<ApiClient>().makeNetworkCall(
          path: path, method: method, params: params, body: body);
      return Right(response);
    } on NetworkConnectionException catch (e) {
      // this is for internet exception handling
      return Left(
        NetworkConnectionException(e.message),
      );
    } on BadRequestException catch (error) {
      // this is for when user enters the wrong credentials
      return Left(
        BadRequestException(error.message),
      );
    } on ServerException catch (error) {
      // this is when the system breaks/when system is down
      return Left(
        ServerException(error.message),
      );
    } on TokenExpiredException catch (error) {
      // logut from the device
      return Left(TokenExpiredException(error.message));
    } on UnDefinedException catch (error) {
      // if any unknown exception occurs then this will handled that exception
      return Left(UnDefinedException(error.message));
    } catch (e) {
      log(e.toString());
      return const Left(
          UnDefinedException("We are facing some issues. Please come back."));
    }
  }
}
