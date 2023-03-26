import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karyakram/core/dependencies.dart';
import 'package:karyakram/presentation/authentication/blocs/authentication/authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final SharedPrefs sharedPrefs;
  AuthenticationCubit({required this.sharedPrefs})
      : super(AuthenticationState.unauthenticated);

  void checkAuthenticaion() {
    if (sharedPrefs.token != null) {
      emit(AuthenticationState.authenticated);
    } else {
      emit(AuthenticationState.unauthenticated);
    }
  }
}
