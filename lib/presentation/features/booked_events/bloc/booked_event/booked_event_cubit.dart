import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karyakram/data/repository/event_repository.dart';
import 'package:karyakram/models/get_events_models.dart';

import '../../../../../config/endpoints.dart';

part 'booked_event_state.dart';

class BookedEventCubit extends Cubit<BookedEventState> {
  final AppRepository appRepository;
  BookedEventCubit({required this.appRepository}) : super(BookedEventInitial());

  void fetchBookedEvents(String userId) async {
    emit(BookedEventFetching());
    var response = await appRepository.repoHandler(
      path: RemoteEndpoints.bookEvent,
      method: 'GET',
      params: {
        "user": userId,
      },
    );
    response.fold(
      (l) => emit(BookedEventFaliure(message: l.message)),
      (r) {
        try {
          var events = List<GetEventResponse>.from(
              r.map((x) => GetEventResponse.fromJson(x)));
          emit(BookedEventFetched(events: events));
        } catch (e) {
          emit(const BookedEventFaliure(message: "Something went wrong"));
        }
      },
    );
  }
}
