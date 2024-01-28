
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/ReservationModel.dart';


class ReservationRangeChooser extends StatefulWidget {

  final Function(Map<String, dynamic>? checkinDateAndNumberOfNights) onReservationDateRangeChanged;
  const ReservationRangeChooser({super.key, required this.onReservationDateRangeChanged});

  @override
  ReservationRangeChooserView createState() => ReservationRangeChooserView();
}

class ReservationRangeChooserView extends State<ReservationRangeChooser> {

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<DateTime> selectedDates = [
  ];
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
  String calculateDateDifference(DateTime startDate, DateTime endDate) {
    Duration difference = endDate.difference(startDate);

    int days = difference.inDays;
    int weeks = days ~/ 7;
    int remainingDays = days % 7;

    int months = (endDate.year - startDate.year) * 12 + endDate.month - startDate.month;

    int years = endDate.year - startDate.year;

    String result = '';

    if (weeks > 0) {
      result += '$weeks week';
      if (weeks > 1) {
        result += 's';
      }
      result += ' ';
    }

    if (remainingDays > 0) {
      result += '$remainingDays night';
      if (remainingDays > 1) {
        result += 's';
      }
      result += ' ';
    }

    if (months > 0) {
      result += '$months month';
      if (months > 1) {
        result += 's';
      }
      result += ' ';
    }

    if (years > 0) {
      result += '$years year';
      if (years > 1) {
        result += 's';
      }
      result += ' ';
    }

    return result.trim();
  }
  void handleDaySelected(DateTime day) {
    // Check if the selected date is today or in the future
    if (day.isAfter(DateTime.now()) || isSameDate(day, DateTime.now())) {
      setState(() {
        // Check if the list already contains two dates
        if (selectedDates.length >= 2) {
          // Clear the list and add the selected date
          selectedDates.clear();
          widget.onReservationDateRangeChanged(null);
        }
        // Check if the list is empty or contains only one date
        if (selectedDates.isEmpty) {
          // Add the selected date to the list
          selectedDates.add(day);
        } else {
          if (selectedDates.length == 1){
            if (day.isAfter(selectedDates.last)) {
              // Add the selected date to the list
              selectedDates.add(day);
              widget.onReservationDateRangeChanged({
                //'checkInDate': "${selectedDates[0].year}-${selectedDates[0].month<12?'0':''}${selectedDates[0].month}-${selectedDates[0].day}",
                'checkInDate': selectedDates[0].toIso8601String(),
                'numberOfNights': selectedDates[1].difference(selectedDates[0]).inDays
              });
            } else {
              // Replace the existing date with the selected one
              selectedDates[0] = day;
            }
          }
          // Sort the list of dates
          //selectedDates.sort();

          // Check if the selected date is after the existing one

        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {

    DateTime today = DateTime.now();
    // Get yesterday's date without time
    _focusedDay = DateTime(today.year, today.month, today.day +2);
    final List<String> items = List.generate(100, (index) => 'Item $index');

    bool compareDatesByDay(DateTime date1, DateTime date2) {
      // Create new DateTime instances with the time part set to midnight
      DateTime midnightDate1 = DateTime(date1.year, date1.month, date1.day);
      DateTime midnightDate2 = DateTime(date2.year, date2.month, date2.day);

      // Compare the resulting DateTime objects
      return midnightDate1.isAtSameMomentAs(midnightDate2);
    }

    return Column( children:[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          selectedDates.length==2?"${calculateDateDifference(selectedDates[0],selectedDates[1])} ":'Book calendar',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (DateTime date) {
            // Check if the date is in the list of selected dates
            if (selectedDates.length==2){
              return ((selectedDates[0].isAtSameMomentAs(date)||(selectedDates[1].isAtSameMomentAs(date))||(selectedDates[0].isBefore(date)&&selectedDates[1].isAfter(date))));
            }else if(selectedDates.length==1){
                return selectedDates[0].isAtSameMomentAs(date);
              }
            else{
              return false;
            }
            //return selectedDates.any((targetDate) => compareDatesByDay(date, targetDate));
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onDaySelected: (selectedDay, focusedDay) {
            handleDaySelected(selectedDay);
          },
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: true,
          ),
        )]);
  }

}
