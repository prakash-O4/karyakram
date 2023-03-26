import 'package:get_it/get_it.dart';
import 'package:karyakram/core/dependencies.dart';
import 'package:karyakram/presentation/features/booked_events/bloc/booked_event/booked_event_cubit.dart';
import 'package:karyakram/presentation/features/event/blocs/book_event/book_event_cubit.dart';

import '../data/api_client/api_client.dart';
import '../data/repository/event_repository.dart';
import '../presentation/authentication/blocs/authentication/authentication_cubit.dart';
import '../presentation/authentication/blocs/login/login_cubit.dart';
import '../presentation/authentication/blocs/register/register_cubit.dart';
import '../presentation/features/event/blocs/event/event_cubit.dart';

var sl = GetIt.instance;

void setUpLocator() {
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => AppRepository());
  sl.registerLazySingleton(() => SharedPrefs.instance);

  sl.registerFactory(() => RegisterCubit(appRepository: sl()));
  sl.registerFactory(() => LoginCubit(appRepository: sl(), sharedPrefs: sl()));
  sl.registerFactory(() => EventCubit(appRepository: sl()));
  sl.registerFactory(() => BookEventCubit(appRepository: sl()));
  sl.registerFactory(() => BookedEventCubit(appRepository: sl()));

  sl.registerFactory(() => AuthenticationCubit(sharedPrefs: sl()));
}
