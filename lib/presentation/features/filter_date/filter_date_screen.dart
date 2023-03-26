import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/config/color_constant.dart';
import 'package:karyakram/di/injector.dart';
import 'package:karyakram/presentation/features/event/blocs/event/event_cubit.dart';

import '../event/components/event_card.dart';

class FilterDateScreen extends StatefulWidget {
  const FilterDateScreen({super.key});

  @override
  State<FilterDateScreen> createState() => _FilterDateScreenState();
}

class _FilterDateScreenState extends State<FilterDateScreen> {
  late EventCubit _eventCubit;
  @override
  void initState() {
    super.initState();
    _eventCubit = sl<EventCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: ColorConstant.primaryColor,
        title: const Text('Filter Date'),
        actions: [
          IconButton(
            onPressed: () {
              showCustomDateRangePicker(
                context,
                dismissible: true,
                minimumDate: DateTime.now(),
                maximumDate: DateTime(2024),
                onApplyClick: (startDate, endDate) {
                  _eventCubit.getEventByDate(
                    startDate: startDate,
                    endDate: endDate,
                  );
                },
                onCancelClick: () {},
                backgroundColor: Colors.white,
                primaryColor: ColorConstant.primaryColor,
              );
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: Padding(
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
                'Filter Event by date.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
