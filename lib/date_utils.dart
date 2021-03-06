class DateUtils {
  static DateTime toMidnight(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static bool isToday(DateTime date) {
    var now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  static bool isPastDay(DateTime date) {
    var today = toMidnight(DateTime.now());
    return date.isBefore(today);
  }

  static DateTime addDaysToDate(DateTime date, int days) {
    DateTime newDate = date.add(Duration(days: days));

    if (date.hour != newDate.hour) {
      var hoursDifference = date.hour - newDate.hour;

      if (hoursDifference <= 3 && hoursDifference >= -3) {
        newDate = newDate.add(Duration(hours: hoursDifference));
      } else if (hoursDifference <= -21) {
        newDate = newDate.add(Duration(hours: 24 + hoursDifference));
      } else if (hoursDifference >= 21) {
        newDate = newDate.add(Duration(hours: hoursDifference - 24));
      }
    }
    return newDate;
  }

  static bool isSpecialPastDay(DateTime date) {
    return isPastDay(date) || (isToday(date) && DateTime.now().hour >= 12);
  }

  static DateTime getFirstDayOfCurrentMonth() {
    var dateTime = DateTime.now();
    dateTime = getFirstDayOfMonth(dateTime);
    return dateTime;
  }

  static DateTime getFirstDayOfNextMonth() {
    var dateTime = getFirstDayOfCurrentMonth();
    dateTime = addDaysToDate(dateTime, 31);
    dateTime = getFirstDayOfMonth(dateTime);
    return dateTime;
  }

  static DateTime getLastDayOfCurrentMonth() {
    return getLastDayOfMonth(DateTime.now());
  }

  static DateTime getLastDayOfNextMonth() {
    return getLastDayOfMonth(getFirstDayOfNextMonth());
  }

  static DateTime addMonths(DateTime fromMonth, int months) {
    DateTime firstDayOfCurrentMonth = fromMonth;
    for (int i = 0; i < months; i++) {
      firstDayOfCurrentMonth =
          getLastDayOfMonth(firstDayOfCurrentMonth).add(Duration(days: 1));
    }

    return firstDayOfCurrentMonth;
  }

  static DateTime getFirstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month);
  }

  static DateTime getLastDayOfMonth(DateTime month) {
    DateTime firstDayOfMonth = DateTime(month.year, month.month);
    DateTime nextMonth = firstDayOfMonth.add(Duration(days: 32));
    DateTime firstDayOfNextMonth = DateTime(nextMonth.year, nextMonth.month);
    return firstDayOfNextMonth.subtract(Duration(days: 1));
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  static bool isCurrentMonth(DateTime date) {
    var now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  }

  static int calculateMaxWeeksNumberMonthly(
      DateTime startDate, DateTime endDate) {
    int monthsNumber = calculateMonthsDifference(startDate, endDate);

    List<int> weeksNumbersMonthly = List();

    if (monthsNumber == 0) {
      return calculateWeeksNumber(startDate, endDate);
    } else {
      weeksNumbersMonthly
          .add(calculateWeeksNumber(startDate, getLastDayOfMonth(startDate)));

      DateTime firstDateOfMonth = getFirstDayOfMonth(startDate);
      for (int i = 1; i <= monthsNumber - 2; i++) {
        firstDateOfMonth = firstDateOfMonth.add(Duration(days: 31));
        weeksNumbersMonthly.add(calculateWeeksNumber(
            firstDateOfMonth, getLastDayOfMonth(firstDateOfMonth)));
      }

      weeksNumbersMonthly
          .add(calculateWeeksNumber(getFirstDayOfMonth(endDate), endDate));

      weeksNumbersMonthly.sort((a, b) => b.compareTo(a));
      return weeksNumbersMonthly[0];
    }
  }

  static int calculateMonthsDifference(DateTime startDate, DateTime endDate) {
    var yearsDifference = endDate.year - startDate.year;
    return 12 * yearsDifference + endDate.month - startDate.month;
  }

  static int calculateWeeksNumber(
      DateTime monthStartDate, DateTime monthEndDate) {
    int rowsNumber = 1;

    DateTime currentDay = monthStartDate;
    while (currentDay.isBefore(monthEndDate)) {
      currentDay = currentDay.add(Duration(days: 1));
      if (currentDay.weekday == DateTime.monday) {
        rowsNumber += 1;
      }
    }

    return rowsNumber;
  }

  static List<DateTime> getDateTimeListBetweenDates(
      DateTime startDate, DateTime endDate,
      {bool skipWeekEnds = true, List<DateTime> datesToSkip}) {
    startDate = DateUtils.toMidnight(startDate);
    endDate = DateUtils.toMidnight(endDate);
    List<DateTime> dateTimesList = List<DateTime>();
    print("GET DATES BETWEEN: $startDate AND $endDate");
    print("DIFFERENCE : ${endDate.difference(startDate).inDays}");
    print("Dates to skip: $datesToSkip");

    for (int i = 0; i < endDate.difference(startDate).inDays; i++) {
      DateTime dateToAdd = startDate.add(Duration(days: i));


      print("Date To Add: ${dateToAdd}");


      if (datesToSkip != null) {
        int indexOfDisabledDate = datesToSkip.indexOf(dateToAdd);
        print(indexOfDisabledDate);

        //DateTime dateToSkipFounded = datesToSkip.firstWhere((element) => element == dateToAdd, orElse: () => null);

        if (indexOfDisabledDate == -1) {
          if (skipWeekEnds) {
            if (dateToAdd.weekday != DateTime.saturday &&
                dateToAdd.weekday != DateTime.sunday) {
              dateTimesList.add(dateToAdd);
            }
          } else {
            dateTimesList.add(dateToAdd);
          }
        }
      } else {
        if (skipWeekEnds) {
          if (dateToAdd.weekday != DateTime.saturday &&
              dateToAdd.weekday != DateTime.sunday) {
            dateTimesList.add(dateToAdd);
          }
        } else {
          dateTimesList.add(dateToAdd);
        }
      }
    }
/*
    do {
      dateToAdd = dateTimesList.last.add(Duration(days: 1));
      if (skipWeekEnds) {
        if (dateToAdd.weekday == DateTime.friday) {
          dateTimesList.add(dateTimesList.last.add(Duration(days: 3)));
        } else if (dateToAdd.weekday == DateTime.saturday) {
          dateTimesList.add(dateTimesList.last.add(Duration(days: 2)));
        }
      }

      if (datesToSkip != null) {
        DateTime dateToSkipFounded = datesToSkip
            .firstWhere((element) => element == dateToAdd, orElse: () => null);

        if (dateToSkipFounded == null) {
          dateTimesList.add(dateToAdd);
        }
      } else {
        dateTimesList.add(dateToAdd);
      }
    } while (dateToAdd.isBefore(endDate));*/

    return dateTimesList;
  }

/*  static DateTime getDateTimeFromWeekDayAndWeekNumber(
      int weekOfMonth, int weekDay, DateTime dateTime) {
    print("Week day ${weekDay}");
    DateTime date = getLastDayOfMonth(dateTime).add(Duration(
        days: weekOfMonth > 1
            ? (DateTime.daysPerWeek * (weekOfMonth - 1)) + (weekDay - 1)
            : weekDay - 1));
    print(date);

    return date;
  }

  static int getWeekNumberOfMonth(DateTime dateTime) {
    int daysToAdd = DateTime.thursday - dateTime.weekday;
    DateTime thursdayDate = daysToAdd > 0
        ? dateTime.add(Duration(days: daysToAdd))
        : dateTime.subtract(Duration(days: daysToAdd.abs()));
    int dayOfYearThursday = thursdayDate
        .difference(DateTime(thursdayDate.year, thursdayDate.month, 1))
        .inDays;
    return 1 + ((dayOfYearThursday - 1) / 7).floor();
  }*/
}
