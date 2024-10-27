import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

var days = <String,int> {
  "Monday": 0,
  "Tuesday": 24,
  "Wednesday": 48,
  "Thursday": 72,
  "Friday": 96,
  "Saturday": 120,
  "Sunday": 144
};

List<String> reqCourses = [
  "CIS*2500",
  "CIS*2520",
  "CIS*2910",
  "STAT*2040",
  "CIS*2430",
  "MATH*1200"
];

Future<List<List<dynamic>>> oCSV() async {
  final file = File("Guelph-engineering-competition-2024/classdates.csv");
  final contents = await file.readAsString();
  List<List<dynamic>> courseList = const CsvToListConverter().convert(contents);
  courseList.removeAt(0);
  courseList.removeAt(0);
  return courseList;
}

String converTo24Hour(String curDay, String timeSTR) {
  List<String> timeParts = timeSTR.split(":");
  String hourStr = timeParts[0];
  String minuteStr = timeParts[1];
  
  String period = minuteStr.substring(minuteStr.length - 2);
  minuteStr = minuteStr.substring(0, 2);
  int hour = int.parse(hourStr);
  int minute = int.parse(minuteStr);

  if (period.toLowerCase() == 'am') {
    if (hour == 12) {
      hour = 0;
    }
  } else { // PM case
    if (hour != 12) {
      hour += 12;
    }
  }

  if (days.containsKey(curDay)) {
    //print(days["Monday"]);
  }
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

List<List<dynamic>> converCSV(List<List<dynamic>> courseList) {
  List<List<dynamic>> hour24List = [];
  for (var item1 in courseList) {
    List<dynamic> tempList = [];
    tempList.add(item1[0]);
    for (var entry in item1) {
      if (entry.contains('|')) {
        List<String> parts = entry.split("|");
        String day = parts[0];
        List<String> times = parts[1].split("-");

        tempList.add(converTo24Hour(day, times[0]));
        tempList.add(converTo24Hour(day, times[1]));
      }
    }
    hour24List.add(tempList);
  }
  return hour24List;
}

// void main() async {
//   List<List<dynamic>> courseList = await oCSV();
//   List<List<dynamic>> hour24List = converCSV(courseList);
//   //print(hour24List);
// }