import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/core/dependencies.dart';
import 'package:karyakram/di/injector.dart';
import 'package:karyakram/presentation/features/booked_events/bloc/booked_event/booked_event_cubit.dart';
import 'package:karyakram/presentation/features/booked_events/booked_events_list.dart';
import 'package:karyakram/presentation/features/event/event_list.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _cuurentIndex = 0;
  final screens = [
    const EventList(),
    const BookedEventList(),
  ];
  @override
  void initState() {
    super.initState();
    String userId = sl<SharedPrefs>().userId ?? '0';
    BlocProvider.of<BookedEventCubit>(context).fetchBookedEvents(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_cuurentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _cuurentIndex,
        onTap: (value) {
          setState(() {
            _cuurentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Booked',
          ),
        ],
      ),
    );
  }
}
