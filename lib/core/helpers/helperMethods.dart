import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

String getHoursMinutes(DateTime? dateTime, String hoursOrMinutesOrBoth) {
  var convertedTime;
  switch (hoursOrMinutesOrBoth.toLowerCase()) {
    case "hours":
      convertedTime = new DateFormat('HH').format(dateTime!);
      return convertedTime;
    case "minutes":
      var convertedTime = new DateFormat('mm').format(dateTime!);
      return convertedTime;
    default:
      convertedTime = new DateFormat('HH:mm').format(dateTime!);
      return convertedTime;
  }
}

String getWeekDay(String? dayNumber) {
  switch (dayNumber) {
    case "1":
      return "maandaag";
    case "2":
      return "dinsdag";
    case "3":
      return "woensdag";
    case "4":
      return "maandaag";
    case "5":
      return "maandaag";
    case "6":
      return "maandaag";
    case "7":
      return "maandaag";
    default:
      return "maandaag";
  }
}

String getDateOnly(DateTime? dateTime) {
  var convertedDate = dateTime!.year.toString() +
      "-" +
      dateTime.month.toString() +
      "-" +
      dateTime.day.toString();
  return convertedDate;
}

getTotalWorkHours(String? startTimeString, String? endTimeString) {
  DateTime startTime = DateTime.parse(startTimeString!);
  DateTime endTime = DateTime.parse(endTimeString!);
  Duration workingHours = endTime.difference(startTime);
  var convertedWorkingHours = workingHours.inMinutes / 60;

  return convertedWorkingHours;
}

String getMonthString(int month) {
  switch (month) {
    case 1:
      return "januari";
    case 2:
      return "februari";
    case 3:
      return "maart";
    case 4:
      return "april";
    case 5:
      return "mei";
    case 6:
      return "juni";
    case 7:
      return "juli";
    case 8:
      return "augustus";
    case 9:
      return "september";
    case 10:
      return "oktober";
    case 11:
      return "november";
    case 12:
      return "december";
    default:
      return DateTime.now().month.toString();
  }
}

performCall(String value) {
  if (value.isEmpty) return;
  launchUrlString("tel://" + value);
}

performEmail(String emailString) async {
  if (emailString.isEmpty) return;
  final Email email = Email(
    recipients: [emailString],
  );
  try {
    await FlutterEmailSender.send(email);
  } catch (e) {
    throw Exception(e.toString());
  }
}
