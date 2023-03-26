import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/config/color_constant.dart';
import 'package:karyakram/core/dependencies.dart';
import 'package:karyakram/presentation/authentication/login/login_screen.dart';
import 'package:karyakram/presentation/features/event/blocs/event/event_cubit.dart';
import 'package:karyakram/presentation/features/event/components/event_card.dart';
import 'package:karyakram/presentation/features/event/components/search_screen.dart';
import 'package:karyakram/presentation/shared_components/dialog_utils.dart';

import '../../../di/injector.dart';
import '../filter_date/filter_date_screen.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late EventCubit _eventCubit;
  @override
  void initState() {
    super.initState();
    _eventCubit = BlocProvider.of<EventCubit>(context);
    _eventCubit.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Event List',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FilterDateScreen()));
            },
            icon: const Icon(
              Icons.calendar_month,
            ),
          ),
          //log out
          IconButton(
            onPressed: () async {
              bool result = await DialogUtils.showConfirmationDialog(
                    context,
                    "Logout",
                    "Are you sure you want to logout?",
                  ) ??
                  false;
              if (result && mounted) {
                bool isLogOut = await sl<SharedPrefs>().logout();
                if (isLogOut && mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => route.isCurrent,
                  );
                }
              }
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upcoming Events",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<EventCubit, EventState>(
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
                              'No events found',
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
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
