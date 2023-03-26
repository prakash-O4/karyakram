import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/config/color_constant.dart';
import 'package:karyakram/presentation/features/booked_events/bloc/booked_event/booked_event_cubit.dart';

import '../event/components/event_card.dart';

class BookedEventList extends StatelessWidget {
  const BookedEventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Events'),
        backgroundColor: ColorConstant.primaryColor,
        elevation: 0.6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<BookedEventCubit, BookedEventState>(
          builder: (context, state) {
            if (state is BookedEventFetched) {
              return state.events.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: state.events[index],
                          showBooking: false,
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'You haven\'t booked any event yet.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    );
            } else if (state is BookedEventFaliure) {
              return Center(
                child: Text(
                  state.message,
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
