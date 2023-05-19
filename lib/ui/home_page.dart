import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note_calendar/controllers/task_controller.dart';
import 'package:note_calendar/event.dart';
import 'package:note_calendar/models/task.dart';
import 'package:note_calendar/services/noti_services.dart';
import 'package:note_calendar/services/theme_services.dart';
import 'package:note_calendar/ui/add_task_bar.dart';
import 'package:note_calendar/ui/theme.dart';
import 'package:note_calendar/ui/widgets/button.dart';
import 'package:note_calendar/ui/widgets/task_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<DateTime, List<Event>> selectedEvents = {};
  var notifyHelper;
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();

  DateTime selectedDay = DateTime.now(); // table calendar에 사용
  DateTime focusedDay = DateTime.now(); // table calendar에 사용
  final _taskController = Get.put(TaskController());

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              // if (task.repeat == 'Daily') {
              //   return AnimationConfiguration.staggeredList(
              //     position: index,
              //     child: SlideAnimation(
              //       child: FadeInAnimation(
              //         child: Row(
              //           children: [
              //             GestureDetector(
              //               onTap: () {
              //                 _showBottomSheet(context, task);
              //               },
              //               child: TaskTile(task),
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   );
              // }
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 20,
              blurRadius: 20,
              offset: const Offset(0, -5), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
        ),
        padding: const EdgeInsets.only(
          top: 7,
        ),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.25
            : MediaQuery.of(context).size.height * 0.33,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: 'Task Completed',
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context,
                  ),
            _bottomSheetButton(
              label: 'Delete Task',
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: const Color(0xFFFF4667),
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              label: 'Close',
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
              context: context,
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          // border: Border.all(
          //   width: 2,
          //   color: isClose == true
          //       ? Get.isDarkMode
          //           ? Colors.grey[600]!
          //           : Colors.grey[300]!
          //       : clr,
          // ),
          color: isClose == true ? Colors.white : clr,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Get.isDarkMode
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 7,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle.copyWith(
                    color: Colors.black,
                  )
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 20,
      ),
      child: DatePicker(
        DateTime(2023, 5, 17),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),

      // child: TableCalendar(
      //   focusedDay: _selectedDate,
      //   firstDay: DateTime(1990),
      //   lastDay: DateTime(DateTime.now().year + 20),
      //   calendarFormat: format,
      //   onFormatChanged: (CalendarFormat format) {
      //     setState(() {
      //       this.format = format;
      //     });
      //   },
      //   startingDayOfWeek: StartingDayOfWeek.sunday,
      //   daysOfWeekVisible: true,

      //   // 날짜 변경
      //   onDaySelected: (DateTime selectDay, DateTime focusDay) {
      //     setState(() {
      //       selectedDay = selectDay;
      //       focusedDay = focusDay;
      //     });
      //   },

      //   eventLoader: _getEventsfromDay,

      //   // 캘린더 디자인
      //   calendarStyle: const CalendarStyle(
      //     isTodayHighlighted: true,
      //     selectedDecoration: BoxDecoration(
      //       color: Colors.blueGrey,
      //       shape: BoxShape.circle,
      //     ),
      //     selectedTextStyle: TextStyle(
      //       // 선택한 날짜
      //       color: Colors.white,
      //     ),
      //     todayDecoration: BoxDecoration(
      //       // 현재 날짜
      //       color: Colors.blue,
      //       shape: BoxShape.circle,
      //     ),
      //     defaultDecoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //     ),
      //     weekendDecoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //     ),
      //   ),
      //   selectedDayPredicate: (DateTime date) {
      //     return isSameDay(selectedDay, date);
      //   },
      //   headerStyle: HeaderStyle(
      //     formatButtonVisible: true, // 단위 포맷버튼 유무
      //     titleCentered: true,
      //     formatButtonShowsNext: false,
      //     formatButtonDecoration: BoxDecoration(
      //       // 포맷버튼 디자인
      //       color: Colors.blue,
      //       borderRadius: BorderRadius.circular(5.0),
      //     ),
      //     formatButtonTextStyle: const TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(
                        DateTime.now(),
                      ),
                      style: subHeadingStyle,
                    ),
                    Text(
                      'Today',
                      style: headingStyle,
                    ),
                  ],
                ),
              ),
              MyButton(
                label: '+ Add Task',
                onTap: () async {
                  await Get.to(
                    const AddTaskPage(),
                  );
                  _taskController.getTask();
                },
              ),
            ],
          ),
          // MyInputField(
          //   title: 'Date',
          //   hint: DateFormat.yMd().format(_selectedDate),
          //   widget: IconButton(
          //     icon: const Icon(
          //       Icons.calendar_today_outlined,
          //       color: Colors.grey,
          //     ),
          //     onPressed: () {
          //       _getDateFromUser();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(DateTime.now().year + 20),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      print("it's null or something is wrong");
    }
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          ThemeService().SwitchTheme();
          notifyHelper.displayNotification(
            title: 'Theme Changed',
            body: Get.isDarkMode
                ? 'Activated light Theme'
                : 'Activated Dark Theme',
          );
          // notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.light_mode_rounded : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }
}
