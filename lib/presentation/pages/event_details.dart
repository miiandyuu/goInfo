import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Event Details'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Image.asset('assets/images/testEvent.webp'),
            const Text('Event Title'),
            const Text('Event Details'),
            const Text('Event Date'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add Notification'),
            ),
            const Text('Featured Pokemons'),
          ]),
        ));
  }
}
