import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils.dart';
import 'event_details.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  int? _selectedEventIndex;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEventIndex = null;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Calendar')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 12.0),
          Text.rich(
            // TODO: Enhance UI and UX
            TextSpan(
                text: 'Event on ',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          '${_selectedDay?.day ?? 'None'} ${DateFormat('MMMM').format(_selectedDay ?? DateTime.now())}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ))
                ]),
          ),
          const SizedBox(height: 8.0),
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: _selectedEvents,
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  bool isExpanded = index == _selectedEventIndex;
                  //TODO: Make this into a widget
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: isExpanded ? 200.0 : 88.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2.0),
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                              // TODO: Change this to a real image from data asset repository
                              image: const AssetImage(
                                  'assets/images/testEvent.webp'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken))),
                      child: ListTile(
                        title: SizedBox(
                          height: 100.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TODO: Change this to a real event name from data asset repository
                              Text(
                                'EVENT NAME ${value[index]}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23.0,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4.0),
                              // TODO: Change this to a real event details from data asset repository
                              Text('$_selectedDay',
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        // TODO: Better animation for the expansion, match the animation with the container
                        subtitle: isExpanded
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 56.0,
                                        width: 56.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        // TODO: Make this into a slideshow of the pokemon shiny and normal form
                                        // TODO: Add notification message at the container either its a new pokemon or a new shiny
                                        // TODO: Find a better background color for the container
                                        child: Image.asset(
                                            'assets/images/pokemon_icon_001_00.png',
                                            scale: 2),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        height: 56.0,
                                        width: 56.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Image.asset(
                                            'assets/images/pokemon_icon_004_00.png',
                                            scale: 2),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        height: 56.0,
                                        width: 56.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Image.asset(
                                            'assets/images/pokemon_icon_007_00.png',
                                            scale: 2),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const EventDetails(),
                                            ));
                                      },
                                      child: const Text('Details')),
                                ],
                              )
                            : null,
                        contentPadding: const EdgeInsets.all(16.0),
                        onTap: () {
                          setState(() {
                            _selectedEventIndex = isExpanded ? null : index;
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
