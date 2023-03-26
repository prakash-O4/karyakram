import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:karyakram/core/dependencies.dart';
import 'package:karyakram/core/environments.dart';
import 'package:karyakram/presentation/authentication/blocs/authentication/authentication_cubit.dart';
import 'package:karyakram/presentation/authentication/blocs/authentication/authentication_state.dart';
import 'package:karyakram/presentation/authentication/blocs/login/login_cubit.dart';
import 'package:karyakram/presentation/authentication/blocs/register/register_cubit.dart';
import 'package:karyakram/presentation/authentication/register/register_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/presentation/base/base_page.dart';
import 'package:karyakram/presentation/features/booked_events/bloc/booked_event/booked_event_cubit.dart';
import 'package:karyakram/presentation/features/event/blocs/book_event/book_event_cubit.dart';
import 'package:karyakram/presentation/features/event/blocs/event/event_cubit.dart';

import 'core/servers.dart';
import 'data/api_client/api_client.dart';
import 'di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  await SharedPrefs.init();
  setServer();
  runApp(const MyApp());
}

setServer() {
  if (kDebugMode) {
    sl<ApiClient>().init(server: TestServer());
  } else {
    if (EnvironmentConfig.server == "test") {
      sl<ApiClient>().init(server: TestServer());
    } else {
      sl<ApiClient>().init(server: TestServer());
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthenticationCubit>()..checkAuthenticaion(),
        ),
        BlocProvider(
          create: (context) => sl<RegisterCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<LoginCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<EventCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<BookEventCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<BookedEventCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Builder(builder: (context) {
          AuthenticationState state =
              BlocProvider.of<AuthenticationCubit>(context).state;
          if (state == AuthenticationState.authenticated) {
            return const BasePage();
          }
          return const RegisterScreen();
        }),
      ),
    );
  }
}
