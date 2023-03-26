import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karyakram/data/repository/event_repository.dart';

import '../../../../../config/endpoints.dart';

part 'book_event_state.dart';

class BookEventCubit extends Cubit<BookEventState> {
  final AppRepository appRepository;
  BookEventCubit({required this.appRepository}) : super(BookEventInitial());
  void bookEvent(String userId, String eventId, String ticketId) async {
    emit(BookEventLoading());
    var response = await appRepository.repoHandler(
      path: RemoteEndpoints.bookEvent,
      method: 'POST',
      body: {
        "user": userId,
        "event": eventId,
        "ticket": ticketId,
      },
    );
    response.fold(
      (l) => emit(BookEventError(message: l.message)),
      (r) {
        try {
          emit(BookEventLoaded());
        } catch (e) {
          emit(const BookEventError(message: "Something went wrong"));
        }
      },
    );
  }
}
