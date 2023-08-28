import 'package:flutter/material.dart';
import 'presentation/pages/event_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((value) => runApp(const GoInfoApp()));
}

class GoInfoApp extends StatelessWidget {
  const GoInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EventCalendar(),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Go Info'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const EventCalendar(),
//                   )),
//               child: const Text('Event Calendar'),
//             ),
//             const SizedBox(
//               height: 12.0,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }