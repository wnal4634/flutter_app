import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:note_calendar/controllers/task_controller.dart';
import 'package:note_calendar/db/db_helper.dart';
import 'package:note_calendar/services/theme_services.dart';
import 'package:note_calendar/ui/home_page.dart';
import 'package:note_calendar/ui/theme.dart';

void main() async {
  final taskController = Get.put(TaskController());
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  taskController.getTask();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const HomePage(),
    );
  }
}
