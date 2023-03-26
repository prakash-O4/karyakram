import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karyakram/config/endpoints.dart';
import 'package:karyakram/data/repository/event_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AppRepository appRepository;
  RegisterCubit({required this.appRepository}) : super(RegisterInitial());

  void register(
      {required String email,
      required String password,
      required String fullName}) async {
    emit(RegisterLoading());
    var response = await appRepository.repoHandler(
      path: RemoteEndpoints.register,
      method: "POST",
      body: {
        "email": email,
        "password": password,
        "first_name": fullName.split(" ").first,
        "last_name": fullName.split(" ").last,
      },
    );
    response.fold(
      (l) => emit(RegisterFailure(message: l.message)),
      (r) => emit(
        RegisterSuccess(),
      ),
    );
  }
}
