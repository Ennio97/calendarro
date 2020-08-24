import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CalendarroDayItem extends StatelessWidget {
  CalendarroDayItem({this.date, this.calendarroState, this.onTap, this.events});

  DateTime date;
  CalendarroState calendarroState;
  DateTimeCallback onTap;
  List<dynamic> events;
  int maxEventTileWidget = 2;


  @override
  Widget build(BuildContext context) {
    bool isWeekend = DateUtils.isWeekend(date);
    var textColor = isWeekend ? Colors.grey : Colors.black;
    bool isToday = DateUtils.isToday(date);
    calendarroState = Calendarro.of(context);

    bool daySelected = calendarroState.isDateSelected(date);

    BoxDecoration boxDecoration;
    if (daySelected) {
      boxDecoration = BoxDecoration(color: Colors.blue, shape: BoxShape.circle);
    } else if (isToday) {
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          shape: BoxShape.circle);
    }

    List<Widget> dayWidgets = List<Widget>();

    dayWidgets.add(
      Container(
          height: 40.0,
          decoration: boxDecoration,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "${date.day}",
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
          )),
    );
    if (events != null && !daySelected) {
      dayWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: _buildEventTileList(events),
      ));
    }

    return Expanded(
        child: GestureDetector(
      child: Center(
        child: Stack(alignment: Alignment.bottomCenter, children: dayWidgets),
      ),
      onTap: handleTap,
      behavior: HitTestBehavior.translucent,
    ));
  }

  void handleTap() {
    if (onTap != null) {
      onTap(date,events);
    }

    calendarroState.setSelectedDate(date);
    calendarroState.setCurrentDate(date);

  }

  List<Widget> _buildEventTileList(List<dynamic> events) {
    List<Widget> eventsChildren = List<Widget>();

    for (int i = 0; i < maxEventTileWidget; i++) {
      eventsChildren.add(_buildEventTile());
      if (i < maxEventTileWidget - 1) {
        eventsChildren.add(SizedBox(width: 4.0,));
      }
    }

    return eventsChildren;
  }

  Widget _buildEventTile() {
    return Container(
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
