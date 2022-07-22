import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:work_order_app/presentation/widgets/datetimePicker/button_widget.dart';

import '../../../app_localizations.dart';
import '../../styles/colors_style.dart';

class DateTimeRangePickerWidget extends StatefulWidget {
  final ValueChanged<DateTime> updateStartDate;
  final ValueChanged<DateTime> updateEndDate;
  final DateTime? startDateTime;
  final DateTime? endDateTime;

  DateTimeRangePickerWidget(this.updateStartDate, this.updateEndDate,
      this.startDateTime, this.endDateTime);

  @override
  State<DateTimeRangePickerWidget> createState() =>
      _DateTimeRangePickerWidgetState();
}

class _DateTimeRangePickerWidgetState extends State<DateTimeRangePickerWidget> {
  String? resultString;
  String? _totalHours = "";
  String? startDateRange;
  String? endDateRange;

  void initState() {
    super.initState();
    if (widget.startDateTime != null) {
      startDateRange =
          DateFormat('dd/MM/yyyy HH:mm').format(widget.startDateTime!);
      endDateRange = DateFormat('dd/MM/yyyy HH:mm').format(widget.endDateTime!);

      var fixedStart = new DateTime(startDateTime!.year, startDateTime!.month,
          startDateTime!.day, startDateTime!.hour, startDateTime!.minute);

      var fixedEnd = new DateTime(endDateTime!.year, endDateTime!.month,
          endDateTime!.day, endDateTime!.hour, endDateTime!.minute);

      final newDateRange =
          (fixedEnd.difference(fixedStart).inMinutes / 60).toDouble();
      _totalHours = newDateRange.toStringAsFixed(2);
    }
  }

  List<DateTime>? dateTimeList;
  DateTime? startDateTime = new DateTime.now();
  DateTime? endDateTime = new DateTime.now().add(
    const Duration(hours: 1),
  );

  String getFrom() {
    if (startDateRange == null) {
      return AppLocalizations.of(context)!
          .translate('work.order.add.edit.hours.page.select.start.time');
    } else {
      return startDateRange.toString();
    }
  }

  String getUntil() {
    if (endDateRange == null) {
      return AppLocalizations.of(context)!
          .translate('work.order.add.edit.hours.page.select.end.time');
    } else {
      return endDateRange.toString();
    }
  }

  @override
  Widget build(BuildContext context) => HeaderWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('work.order.add.edit.hours.page.start.time'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: CustomColors.black,
                  ),
                ),
              ),
            ),
            Container(
              child: ButtonWidget(
                text: getFrom(),
                onClicked: () => {pickStartDateTimeRange(context)},
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('work.order.add.edit.hours.page.end.time'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: CustomColors.black),
                ),
              ),
            ),
            Container(
              child: ButtonWidget(
                text: getUntil(),
                onClicked: () => pickEndDateTimeRange(context),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                          AppLocalizations.of(context)!.translate(
                              'work.order.add.edit.hours.page.total.hours'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: CustomColors.black)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      border: Border.all(
                        width: 1,
                        color: CustomColors.greyBorder,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          5.0,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                5.0,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            _totalHours.toString(),
                            style: TextStyle(
                              color: CustomColors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Future pickStartDateTimeRange(BuildContext context) async {
    startDateTime = DateTime.now();
    startDateTime = await showOmniDateTimePicker(
      context: context,
      primaryColor: Colors.cyan,
      backgroundColor: Colors.grey[900],
      calendarTextColor: Colors.white,
      tabTextColor: Colors.white,
      unselectedTabBackgroundColor: Colors.grey[700],
      buttonTextColor: Colors.white,
      timeSpinnerTextStyle:
          const TextStyle(color: Colors.white70, fontSize: 18),
      timeSpinnerHighlightedTextStyle:
          const TextStyle(color: Colors.white, fontSize: 24),
      is24HourMode: true,
      isShowSeconds: false,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime.now().subtract(const Duration(days: 30)),
      startLastDate: startDateTime?.add(
        const Duration(days: 0),
      ),
      borderRadius: const Radius.circular(16),
    );

    if (startDateTime != null) {
      setState(() => startDateRange =
          DateFormat('dd/MM/yyyy HH:mm').format(startDateTime!));
    }
  }

  Future pickEndDateTimeRange(BuildContext context) async {
    endDateTime = await showOmniDateTimePicker(
      context: context,
      primaryColor: Colors.cyan,
      backgroundColor: Colors.grey[900],
      calendarTextColor: Colors.white,
      tabTextColor: Colors.white,
      unselectedTabBackgroundColor: Colors.grey[700],
      buttonTextColor: Colors.white,
      timeSpinnerTextStyle:
          const TextStyle(color: Colors.white70, fontSize: 18),
      timeSpinnerHighlightedTextStyle:
          const TextStyle(color: Colors.white, fontSize: 24),
      is24HourMode: true,
      isShowSeconds: false,
      startInitialDate: startDateTime,
      startFirstDate: startDateTime,
      startLastDate: startDateTime,
      borderRadius: const Radius.circular(16),
    );

    if (endDateTime != null) {
      var fixedStart = new DateTime(startDateTime!.year, startDateTime!.month,
          startDateTime!.day, startDateTime!.hour, startDateTime!.minute);

      var fixedEnd = new DateTime(endDateTime!.year, endDateTime!.month,
          endDateTime!.day, endDateTime!.hour, endDateTime!.minute);

      final newDateRange =
          (fixedEnd.difference(fixedStart).inMinutes / 60).toDouble();
      if (newDateRange > 0) {
        widget.updateStartDate(fixedStart);
        widget.updateEndDate(fixedEnd);
        setState(() => startDateRange =
            DateFormat('dd/MM/yyyy HH:mm').format(startDateTime!));
        setState(() =>
            endDateRange = DateFormat('dd/MM/yyyy HH:mm').format(endDateTime!));
        setState(() => _totalHours = newDateRange.toStringAsFixed(2));
      } else if (newDateRange == 0.0) {
        setState(() => endDateRange = AppLocalizations.of(context)!.translate(
            'work.order.add.edit.hours.page.info.select.start.time'));
      } else {
        setState(() => endDateRange = AppLocalizations.of(context)!
            .translate('work.order.add.edit.hours.page.info.select.end.time'));
      }
    }
  }
}
