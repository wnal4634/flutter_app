import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ㅙㅙ'),
        centerTitle: true,
      ),
      body: TableCalendar(
        focusedDay: selectedDay,
        firstDay: DateTime(1990),
        lastDay: DateTime(2050),
        calendarFormat: format,
        onFormatChanged: (CalendarFormat format) {
          setState(() {
            this.format = format;
          });
        },
        startingDayOfWeek: StartingDayOfWeek.sunday,
        daysOfWeekVisible: true,

        // 날짜 변경
        onDaySelected: (DateTime selectDay, DateTime focusDay) {
          setState(() {
            selectedDay = selectDay;
            focusedDay = focusDay;
          });
          print(focusDay);
        },

        // 캘린더 디자인
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: true,
          selectedDecoration: BoxDecoration(
            color: Colors.blueGrey,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            // 선택한 날짜
            color: Colors.white,
          ),
          todayDecoration: BoxDecoration(
            // 현재 날짜
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        selectedDayPredicate: (DateTime date) {
          return isSameDay(selectedDay, date);
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: true, // 단위 포맷버튼 유무
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            // 포맷버튼 디자인
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5.0),
          ),
          formatButtonTextStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
