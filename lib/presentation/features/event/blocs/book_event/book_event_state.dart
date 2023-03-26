part of 'book_event_cubit.dart';

abstract class BookEventState extends Equatable {
  const BookEventState();

  @override
  List<Object> get props => [];
}

class BookEventInitial extends BookEventState {}

class BookEventLoading extends BookEventState {}

class BookEventLoaded extends BookEventState {}

class BookEventError extends BookEventState {
  final String message;
  const BookEventError({required this.message});

  @override
  List<Object> get props => [message];
}