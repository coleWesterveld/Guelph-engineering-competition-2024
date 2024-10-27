import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'user.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'csv_parser.dart';


class Event{
  final String title;
  Event(this.title);
}
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
  List<Appointment> meetings = <Appointment>[];
int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
   return (to.difference(from).inHours / 24).round();
}

    List<String> courses = [
      "CIS*2500",
      "CIS*2520",
      "CIS*2910",
      "STAT*2040",
      "CIS*2430",
      "MATH*1200",
      "FRHD*1100",
      "CIS*1050",
      "MCS*1000",
      "GCSS Meeting",
      "BasketBall Practice",
      "SOCIS Workshop",
      "Debate Club",
    ];

    List<List<String>> courseTimes = [
["0:8:00", "0:9:20", "2:14:30", "2:16:30", "4:14:30", "4:16:30"],
["0:12:20", "0:13:40", "2:17:30", "2:18:20", "4:10:00", "4:12:00"],
["1:18:00", "1:19:00", "3:18:00", "3:19:00", "0:0:00", "0:0:00"],
["1:12:00", "1:13:20", "2:21:00", "2:10:00", "3:10:00", "3:11:00"],
["1:8:00", "1:9:00", "3:15:00", "3:16:00", "0:0:00", "0:0:00"],
["0:18:00", "0:19:00", "2:12:00", "2:13:00", "0:0:00", "0:0:00"],
["0:8:10", "0:9:00", "1:16:00", "1:17:00", "0:0:00", "0:0:00"],
["2:19:00", "2:20:00", "3:19:00", "3:20:00", "0:0:00", "0:0:00"],
["2:14:30", "2:15:30", "4:17:00", "4:18:20", "0:0:00", "0:0:00"],
["0:17:30", "0:18:00", "0:0:00", "0:0:00", "0:0:00", "0:0:00"],
["5:6:00", "5:7:30", "6:6:00", "6:8:00", "0:0:00", "0:0:00"],
["2:19:00", "2:20:30", "0:0:00", "0:0:00", "0:0:00", "0:0:00"],
["1:17:00", "1:17:50", "6:20:00", "6:21:00", "0:0:00", "0:0:00"],
];
List<Appointment> display = <Appointment>[];
Color colorpick = Colors.red;
class SchedulePage extends StatefulWidget {
  

  const SchedulePage({Key? mykey}) : super(key: mykey);
  @override
  _MyScheduleState createState() => _MyScheduleState();
}
// this class contains the list view of expandable card tiles 
// title is day title (eg. 'legs') and when expanded, leg excercises for that day show up
class _MyScheduleState extends State<SchedulePage> {
  DateTime today = DateTime.now();
  Map<DateTime, List<Event>> events = {};
  DateTime startDay = DateTime(2024, 8, 10);
  DateTime? _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;

  List<Appointment> getstuff = []; // Move getstuff to class-level

  late MeetingDataSource _dataSource; // Make the data source a state property

  @override
  void initState() {
    super.initState();
    _selectedDay = today;

    // Initialize the data source with the empty getstuff list
    _dataSource = MeetingDataSource(getstuff);
  }

  List<Appointment> getAppointments(int index) {
  meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  
  // Start time for the appointments
  DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  
  // End time for the appointments (assuming a 2-hour duration)
 // final DateTime endTime = startTime.add(const Duration(hours: 2));

  // For every time in courseTimes[index]
  for (String time in courseTimes[index]) {
    
    if (time == "0:00:00" || time.isEmpty) continue; // Skip if the time is not set

    final parts = time.split(':');
    if (parts.length != 3) continue; // Ensure proper format

      int days = int.parse(parts[0]) + 1;
      int hours = int.parse(parts[1]);
      int minutes = int.parse(parts[2]);

      // Check for valid hour and minute values
      if (hours < 0 || minutes < 0 || minutes >= 60) continue; // Validate hours and minutes
      //startTime = DateTime(today.year, today.month, today.day + 24 ~/ int.parse(parts[0]), hours, minutes);
      meetings.add(
        Appointment(
          startTime: DateTime(today.year, today.month, today.day + days, hours, minutes),
          endTime: DateTime(today.year, today.month, today.day + days, hours + (hours != 0 ? 2 : 0), minutes),
          subject: courses[index],
          color: Color(0x99505050),
          isAllDay: false,
        ),
      );
    
  }
  print(meetings);
  return display + meetings;
}

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Text("Clear"),
        onPressed: (){setState(() {
          colorpick = Colors.red;
          display = <Appointment> [];
        });
        },),

        body: Row(
        children: [
          SizedBox(
            width: 400,
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              scrollDirection: Axis.vertical,
              itemCount: courses.length, // Use the length of the outer list
              itemBuilder: (context, index) {
                String text = courses[index];

                return ColoredBox(
                  color: index > 8 ? colorpick : Profile.palette[2],
                  child: InkWell(
                    
                    onTap: () {
                      if (index > 8){
                        colorpick = Colors.white;
                      }
                           
                    bool hasOverlap = false;
                    
                    // Loop through the new meetings
                    for (var newMeeting in meetings) {
                      // Check if any appointment in display overlaps with the new one
                      for (var existingMeeting in display) {
                        if (newMeeting.startTime.isBefore(existingMeeting.endTime) &&
                            newMeeting.endTime.isAfter(existingMeeting.startTime) && newMeeting.startTime.hour != 0) {
                          hasOverlap = true;
                          break;
                        }
                      }
                      if (hasOverlap) break; // Exit early if overlap is found
                    }
                  
                    if (!hasOverlap) {
                      // If no overlap, add the new appointments to the display
                      setState(() {
                        for (var day in meetings){
                          day.color = Profile.eventColors[index];
                        }
                        display += meetings;
                      });
                    } else {
                      // Show a snackbar if there's an overlap
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Profile.palette[0],
                          content: Text('Appointment times overlap! Cannot add this course.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  
                  
                    },
                    onHover: (isHovering) {
                      if (isHovering) {
                        setState(() {
                          // Update the list of appointments on hover
                          getstuff = getAppointments(index);
                  
                          // Notify the calendar that the appointments have changed
                          _dataSource.appointments = getstuff;
                          _dataSource.notifyListeners(CalendarDataSourceAction.reset, getstuff);
                        });
                      }
                    },
                    child: ListTile(
              
                      hoverColor: Colors.black,
                      title: Text(text),
                      leading: Icon(Icons.book),
                    ),
                  ),
                );
              },
            ),
          ),
          // Calendar that updates when getstuff changes
          SizedBox(
            width: MediaQuery.of(context).size.width - 400,
            child: SfCalendar(
              view: CalendarView.week,
              dataSource: _dataSource, // Use the data source here
            ),
          ),
        ],
      ),
    );
  }
}
