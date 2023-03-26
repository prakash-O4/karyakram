import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karyakram/config/endpoints.dart';
import 'package:karyakram/data/repository/event_repository.dart';
import 'package:karyakram/models/get_events_models.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final AppRepository appRepository;
  EventCubit({required this.appRepository}) : super(EventInitial());

  void fetchEvents() async {
    emit(EventLoading());
    var response = await appRepository.repoHandler(
      path: RemoteEndpoints.events,
      method: 'GET',
    );
    response.fold(
      (l) => emit(EventError(message: l.message)),
      (r) {
        try {
          var events = List<GetEventResponse>.from(
              r.map((x) => GetEventResponse.fromJson(x)));
          emit(EventLoaded(events: events));
        } catch (e) {
          emit(const EventError(message: "Something went wrong"));
        }
      },
    );
  }

  void getEventByAddress(String address) async {
    emit(EventLoading());
    var response = await appRepository
        .repoHandler(path: RemoteEndpoints.events, method: 'GET', params: {
      "address": address.trim(),
    });
    response.fold(
      (l) => emit(EventError(message: l.message)),
      (r) {
        try {
          var events = List<GetEventResponse>.from(
              r.map((x) => GetEventResponse.fromJson(x)));
          emit(EventLoaded(events: events));
        } catch (e) {
          emit(const EventError(message: "Something went wrong."));
        }
      },
    );
  }

  void getEventByDate({DateTime? startDate, DateTime? endDate}) async {
    emit(EventLoading());
    var response = await appRepository.repoHandler(
      path: RemoteEndpoints.events,
      method: 'GET',
      params: {
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String()
      },
    );
    response.fold(
      (l) => emit(EventError(message: l.message)),
      (r) {
        try {
          var events = List<GetEventResponse>.from(
              r.map((x) => GetEventResponse.fromJson(x)));
          emit(EventLoaded(events: events));
        } catch (e) {
          emit(const EventError(message: "Something went wrong"));
        }
      },
    );
  }
}
