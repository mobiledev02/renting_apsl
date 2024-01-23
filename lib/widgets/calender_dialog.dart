import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renting_app_mobile/constants/img_font_color_string.dart';

import '../calender/src/customization/calendar_style.dart';
import '../calender/src/customization/header_style.dart';
import '../calender/src/shared/utils.dart';
import '../calender/src/table_calendar.dart';

CalendarFormat _calendarFormat = CalendarFormat.month;
// DateTime _focusedDay = DateTime.now();
// DateTime? _selectedDay;

void showCalender({
  required BuildContext context,
  required Function(DateTime)? setDateOnCallBack,
  DateTime? firstDate,
  DateTime? currentDate,
  DateTime? focusedDay,
  DateTime? selectedDay,
  String? labelText,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Container(
        height: 310,
        width: 500,
        // margin: const EdgeInsets.all(27),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cust000000.withOpacity(0.1),
              blurRadius: 20.0,
              // spreadRadius: 20.00,
            ),
          ],
        ),
        child: TableCalendar(
          rowHeight: 34,
          currentDay: currentDate,
          firstDay: firstDate ?? DateTime.now(),
          lastDay: DateTime(DateTime.now().year + 1),
          focusedDay: focusedDay ?? DateTime.now(),
          calendarFormat: _calendarFormat,
          calendarStyle: CalendarStyle(
            cellMargin: const EdgeInsets.symmetric(horizontal: 5),
            todayDecoration: BoxDecoration(
              color: selectedDay?.toIso8601String().isEmpty ?? true
                  ? primaryColor
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            todayTextStyle: const TextStyle(
              color: custB5B5B5,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            outsideTextStyle: const TextStyle(
              color: custE4E4E4,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            defaultTextStyle: const TextStyle(
              color: custB5B5B5,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            weekendTextStyle: const TextStyle(
              color: custB5B5B5,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          daysOfWeekHeight: 50,
          headerStyle: HeaderStyle(
            leftChevronPadding: EdgeInsets.zero,
            rightChevronPadding: EdgeInsets.zero,
            leftChevronMargin: const EdgeInsets.only(left: 37.25),
            rightChevronMargin: const EdgeInsets.only(right: 37.5),
            titleTextFormatter: (date, locale) => labelText != null
                ? '$labelText\n${DateFormat('MMMM, y').format(date)}'
                : DateFormat('MMMM, y').format(date),
            rightChevronIcon: const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
            leftChevronIcon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
            formatButtonVisible: false,
            titleTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
            titleCentered: true,
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay ?? DateTime.now(), day);
          },
          onDaySelected: (_selectedDay, _focusedDay) {
            
            setDateOnCallBack!(_selectedDay);
            if (!isSameDay(selectedDay, _selectedDay)) {
              // setState(() {
              selectedDay = _selectedDay;
              focusedDay = _focusedDay;
              // });
              //
            }

            // _selectedDay = null;
            Get.back();
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // setState(() {
              _calendarFormat = format;
              // });
            }
          },
          onPageChanged: (focusedDay) {
            focusedDay = focusedDay;
          },
        ),
      ),
    ),
  );
}
