import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_info/presentation/pages/event_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  group('EventCalendar Widget', () {
    testWidgets('Widget initializes and displays the calendar',
        (widgetTester) async {
      await widgetTester.pumpWidget(const MaterialApp(home: EventCalendar()));

      // Verify that the calendar is displayed
      expect(find.byType(EventCalendar), findsOneWidget);
    });

    testWidgets('Selecting a day updates selected day and events',
        (widgetTester) async {
      await widgetTester.pumpWidget(const MaterialApp(home: EventCalendar()));

      // Tap a day in the calendar
      await widgetTester.tap(find.text(
          'Today\'s Event 1')); //TODO: Make this dynamic and print the text of the first event
      await widgetTester.pumpAndSettle();

      // Verify that the selected day is updated
      expect(
          find.text(
              'Event on ${DateTime.now().day} ${DateFormat('MMMM').format(DateTime.now())}'),
          findsOneWidget);

      // Get the number of events generated for the selected day
      final numberOfEvents = find.byType(ListTile).evaluate().length;

      // Verify that there is at least 1 event (ListTile) displayed
      expect(numberOfEvents, greaterThanOrEqualTo(1));
    });
  });
}
