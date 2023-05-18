import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_calendar/models/task.dart';
import 'package:note_calendar/ui/theme.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  const TaskTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task?.color ?? 0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task?.title ?? "",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task?.writeTime ?? '',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      // CircleAvatar(
                      //   radius: 16.5,
                      //   backgroundColor: Colors.black.withOpacity(0.0),
                      //   backgroundImage: AssetImage(
                      //     _getWeather(task?.weather ?? 0),
                      //   ),
                      // )
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcATop,
                        ),
                        child: Image.asset(
                          _getWeather(task?.weather ?? 0),
                          width: 30,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task?.note ?? "",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[100],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task!.isCompleted == 1 ? "COMPLETED" : "TODO",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }

  _getWeather(int no) {
    switch (no) {
      case 0:
        return 'icon/none.png';
      case 1:
        return 'icon/sun.png';
      case 2:
        return 'icon/cloud_sun.png';
      case 3:
        return 'icon/cloud.png';
      case 4:
        return 'icon/cloudy.png';
      case 5:
        return 'icon/wind.png';
      case 6:
        return 'icon/rain.png';
      case 7:
        return 'icon/snow.png';
      case 8:
        return 'icon/thunder.png';
      default:
        return 'icon/none.png';
    }
  }
}
