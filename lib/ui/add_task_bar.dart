import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_calendar/controllers/task_controller.dart';
import 'package:note_calendar/models/task.dart';
import 'package:note_calendar/ui/theme.dart';
import 'package:note_calendar/ui/widgets/button.dart';
import 'package:note_calendar/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final String _startTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedColor = 0;
  int _selectedWeather = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              _weatherPallete(),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  MyButton(
                    label: 'Create Task',
                    onTap: () => _validateDate(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fields are required !',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
        ),
      );
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        color: _selectedColor,
        weather: _selectedWeather,
        isCompleted: 0,
      ),
    );
    print('My id is ' '$value');
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  _weatherPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weather',
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedWeather = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 14,
                    // backgroundColor: index == 0
                    //     ? primaryClr
                    //     : index == 1
                    //         ? pinkClr
                    //         : yellowClr,

                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage('icon/sunny.png'),

                    child: _selectedWeather == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.black,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
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

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(
          _startTime.split(':')[0],
        ),
        minute: int.parse(
          _startTime.split(':')[1].split(' ')[0],
        ),
      ),
    );
  }
}
