import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note_calendar/calendar.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "ESTech Calendar",
      home: Calendar(),
    );
  }
}
