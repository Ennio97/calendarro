import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Calendarro Demo',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new MyHomePage(title: 'Calendarro Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  Calendarro monthCalendarro;

  Map<DateTime, dynamic> events = new Map<DateTime, dynamic>();
  List<DateTime> datesDisabled = new List<DateTime>();
  List<DateTime> dateBetweenRange = new List<DateTime>();

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var startDate = DateUtils.getFirstDayOfCurrentMonth();
    var endDate = startDate.add(Duration(days: 365));

    dateBetweenRange = DateUtils.getDateTimeListBetweenDates(
      DateTime.now(),
      DateTime.now().add(Duration(days: 10)),
      skipWeekEnds: true,
      datesToSkip: [
        new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2),
        new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 5),
        new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
        new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3),
      ],
    );
    print("==========START GET DATE RANGE LIST============");

    dateBetweenRange.forEach((element) {
      print("${element.day}-${element.month}-${element.year}");
    });
    print("==========END GET DATE RANGE LIST============");

    datesDisabled = [
      new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 7)),
      new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 20)),
      new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 5)),
      new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 13)),
      new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 3))
    ];

    events = {
      new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day): [
        {"title": "test", "id": 0},
        {"title": "event2", "id": 1},
      ],
      new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1): [
        {"title": "test3", "id": 0},
        {"title": "event4", "id": 1},
      ],
      new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 2): [
        {"title": "test5", "id": 0},
        {"title": "event6", "id": 1},
        {"title": "event6", "id": 2},
      ],
    };
    monthCalendarro = Calendarro(
        startDate: startDate,
        weekEndDaysEnabled: false,
        datesDisabled: datesDisabled,
        pageSnapping: true,
        events: events,
        selectedDates: [DateTime.now()],
        scrollDirection: Axis.vertical,
        endDate: endDate,
        displayMode: DisplayMode.MONTHS,
        selectionMode: SelectionMode.RANGE,
        weekdayLabelsRow: CustomWeekdayLabelsRow(),
        onTap: (date, events) {
          print("onTap date: $date");
          print("onTap events: $events");
        });
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: Column(
        children: <Widget>[
          /* Container(
            color: Colors.orange,
            child: Calendarro(),
          ),*/
          Container(height: 32.0),
          monthCalendarro
        ],
      ),
    );
  }
}

class CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("M", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("W", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("F", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
      ],
    );
  }
}
