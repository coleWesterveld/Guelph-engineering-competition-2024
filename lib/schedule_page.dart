import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'user.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class Event{
  final String title;
  Event(this.title);
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

  void loadEvents(){
    //
  }

  @override
  void initState(){
    super.initState();
    _selectedDay = today;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    //loadEvents();
  }

  List<Event> _getEventsForDay (DateTime day){
    //get events for that day to display
    //for not, always just says there is an event every day
    return [Event("Sample Event")];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay){
    if (!isSameDay(_selectedDay, selectedDay)){
      setState((){
        _selectedDay = selectedDay;
        today = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
      
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safe to access context.watch<Profile>() here
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    loadEvents(); // You can call loadEvents() here as well, if needed
  }

  @override
  // main scaffold, putting it all together
  Widget build(BuildContext context) {

    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Profile.palette[1],
        centerTitle: true,
        title: const Text(
          "Planner",
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
          ),
      ),
 

      

      //bottomNavigationBar: weekView(),
      body: Row(
        children: [
          SizedBox(
            width: 400,
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              scrollDirection: Axis.vertical,
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Sample Title"), 
                  leading: Icon(Icons.book)
                  );
              }
            ),
          ),
          //ListView.builder(){} //this will come later
          SizedBox(
            width: MediaQuery.of(context).size.width - 400,
            child: SfCalendar(
              view: CalendarView.week,
            ),
          ),
        ],
      ),

      
    );
  }
}