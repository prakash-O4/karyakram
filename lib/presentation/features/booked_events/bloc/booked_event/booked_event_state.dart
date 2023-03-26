part of 'booked_event_cubit.dart';

abstract class BookedEventState extends Equatable {
  const BookedEventState();

  @override
  List<Object> get props => [];
}

class BookedEventInitial extends BookedEventState {}

class BookedEventFetching extends BookedEventState {}

class BookedEventFetched extends BookedEventState {
  final List<GetEventResponse> events;

  const BookedEventFetched({required this.events});

  @override
  List<Object> get props => [events];
}

class BookedEventFaliure extends BookedEventState {
  final String message;

  const BookedEventFaliure({required this.message});

  @override
  List<Object> get props => [message];
}
