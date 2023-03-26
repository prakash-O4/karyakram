import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/config/color_constant.dart';
import 'package:karyakram/config/date_time_extensions.dart';
import 'package:karyakram/core/dependencies.dart';
import 'package:karyakram/di/injector.dart';
import 'package:karyakram/models/get_events_models.dart';
import 'package:karyakram/presentation/features/event/blocs/book_event/book_event_cubit.dart';

import '../../shared_components/dialog_utils.dart';

class EventDescriptionPage extends StatefulWidget {
  final GetEventResponse event;
  final bool showBooking;
  const EventDescriptionPage(
      {super.key, required this.event, this.showBooking = true});

  @override
  State<EventDescriptionPage> createState() => _EventDescriptionPageState();
}

class _EventDescriptionPageState extends State<EventDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<BookEventCubit, BookEventState>(
      listener: (context, state) async {
        if (state is BookEventLoading) {
          DialogUtils.showLoadingDialog(context);
        }
        if (state is BookEventLoaded) {
          Navigator.of(context).pop();
          bool response = await DialogUtils.showSuccessDialog(
                context,
                'Your event is booked.',
              ) ??
              false;
          if (response && mounted) {
            Navigator.popUntil(
              context,
              (route) => route.isFirst,
            );
          }
        }
        if (state is BookEventError) {
          if (mounted) {
            Navigator.of(context).pop();
            DialogUtils.showErrorDialog(
              context,
              'Booking Failed',
              state.message,
            );
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.event.picture ?? '',
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  ),
                ),
                // back button
                Positioned(
                  top: 20,
                  left: 10,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                // event description
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.name ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.event.description ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.event.description ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.event.address ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.event.startDate.toFormatDate(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.event.startDate.getTimeFromTime(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // card for ticket, price and ticket type
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ticket',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              widget.event.ticket?.ticketPrice ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.event.ticket?.ticketType ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  widget.showBooking
                      ? Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: ColorConstant.primaryColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              bool result =
                                  await DialogUtils.showConfirmationDialog(
                                        context,
                                        "Book Event",
                                        "Are you sure you want to book this event?",
                                      ) ??
                                      false;
                              log("Result: $result");
                              if (result && mounted) {
                                String userId = sl<SharedPrefs>().userId ?? "0";
                                BlocProvider.of<BookEventCubit>(context)
                                    .bookEvent(
                                  userId,
                                  widget.event.id.toString(),
                                  widget.event.ticket?.id.toString() ?? '',
                                );
                              }
                            },
                            child: const Text(
                              'Book Event',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
