import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/config/color_constant.dart';
import 'package:karyakram/di/injector.dart';
import 'package:karyakram/presentation/features/event/blocs/event/event_cubit.dart';

import 'event_card.dart';

class SearchScreen extends SearchDelegate {
  final EventCubit _eventCubit = sl<EventCubit>();
  SearchScreen()
      : super(
          searchFieldLabel: 'Search by address',
          searchFieldStyle: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w400,
          ),
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorConstant.primaryColor,
            elevation: 0.4,
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 19,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
          ),
        );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      _eventCubit.getEventByAddress(query);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<EventCubit, EventState>(
        bloc: _eventCubit,
        builder: (context, state) {
          if (state is EventLoaded) {
            return state.events.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.events.length,
                    itemBuilder: (context, index) {
                      return EventCard(event: state.events[index]);
                    },
                  )
                : const Center(
                    child: Text(
                      'No events found.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
          } else if (state is EventError) {
            return Center(
              child: Text(
                state.message,
              ),
            );
          } else if (state is EventLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(
            child: Text(
              'Search event by address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}
