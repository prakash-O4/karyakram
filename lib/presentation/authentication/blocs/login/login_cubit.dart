import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karyakram/core/dependencies.dart';
import 'package:karyakram/data/repository/event_repository.dart';

import '../../../../config/endpoints.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AppRepository appRepository;
  final SharedPrefs sharedPrefs;
  LoginCubit({required this.appRepository, required this.sharedPrefs})
      : super(LoginInitial());

  void login({required String email, required String password}) async {
    emit(LoginLoading());
    var response = await appRepository.repoHandler(
      path: RemoteEndpoints.login,
      method: "POST",
      body: {
        "username": email,
        "password": password,
      },
    );
    response.fold(
      (l) => emit(LoginFailure(message: l.message)),
      (r) async {
        try {
          await sharedPrefs.setToken(r["token"]);
          await sharedPrefs.setUserId(r["user_id"].toString());
          log(sharedPrefs.userId ?? "N/A");
          emit(
            LoginSuccess(),
          );
        } catch (e) {
          log("$e");
          emit(const LoginFailure(message: "Something went wrong"));
        }
      },
    );
  }
}
