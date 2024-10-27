import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'user.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
   return (to.difference(from).inHours / 24).round();
}

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

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    meetings.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: 'Board Meeting',
        color: Colors.blue,
        recurrenceRule: 'FREQ=DAILY;COUNT=10',
        isAllDay: false));

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
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
    ];

    return Scaffold(
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

                return InkWell(
                  onTap: () {},
                  onHover: (isHovering) {
                    if (isHovering) {
                      setState(() {
                        // Update the list of appointments on hover
                        getstuff = getAppointments();

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
