import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/job_offer_controller.dart';
import 'package:renting_app_mobile/models/job_offer_model.dart';
import 'package:renting_app_mobile/widgets/cust_button.dart';
import 'package:renting_app_mobile/widgets/custom_text.dart';

import '../constants/img_font_color_string.dart';
import '../main.dart';
import '../utils/date_time_util.dart';
import 'calender_dialog.dart';
import 'common_widgets.dart';

class LogHoursDialogLender extends StatefulWidget {
  final JobOfferModel offer;

  const LogHoursDialogLender({Key? key, required this.offer}) : super(key: key);

  @override
  State<LogHoursDialogLender> createState() => _LogHoursDialogLenderState();
}

class _LogHoursDialogLenderState extends State<LogHoursDialogLender> {
  DateTime? startDate;
  DateTime? startTime;
  DateTime? endTime;
  TimeOfDay? selectedEndTime, selectStartTime;
  final ValueNotifier _valueNotifier = ValueNotifier(true);
  final jobOfferController = Get.find<JobOfferController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    txtTitle: 'Select Hours',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        txtTitle: 'Maximum Hours: ',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: custGrey),
                      ),
                      CustomText(
                        txtTitle: '${widget.offer.maxHours}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStartDate(context),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildStartTime(context),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildEndTime(context),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButton(
                onPressed: _confirm,
                child: CustomText(
                  txtTitle: 'Confirm',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Start date
  Widget _buildStartDate(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, j, w) => dateTextAndCalenderAndTimeIcon(
        onTap: () => showCalender(
          context: context,
          focusedDay: startDate,
          firstDate: DateTime.now(),
          currentDate: DateTime.now(),
          selectedDay: startDate ?? DateTime.now(),
          setDateOnCallBack: (date) {
            // setState(() {
            startDate = date;

            // serviceDetail.startDate = date;

            // });

            _valueNotifier.notifyListeners();
          },
        ),
        icon: ImgName.calender,
        context: context,
        date: startDate == null
            ? StaticString.startDate
            : StaticString.formatter.format(
                startDate ?? DateTime.now(),
              ),
      ),
    );
  }

  ///  Service start time
  Widget _buildStartTime(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, j, w) => dateTextAndCalenderAndTimeIcon(
        onTap: _startTime,
        icon: ImgName.clock,
        context: context,
        date: startTime == null
            ? StaticString.startTime
            : formatTimeHM(startTime),
      ),
    );
  }

  void _startTime() async {
    selectStartTime = await showTimePicker(
      context: getContext,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    // if (startDate != null &&
    //     DateTime(startDate!.year, startDate!.month, startDate!.day, 0, 0, 0, 0,
    //             0) ==
    //         DateTime(
    //             DateTime.now().year,
    //             DateTime.now().month,
    //             DateTime.now().day,
    //             0,
    //             0,
    //             0,
    //             0,
    //             0)) if (((selectStartTime?.hour ?? 0) < TimeOfDay.now().hour) ||
    //     (((selectStartTime?.hour ?? 0) == TimeOfDay.now().hour) &&
    //         ((selectStartTime?.minute ?? 0) <= TimeOfDay.now().minute))) {
    //   Get.showSnackbar(
    //     const GetSnackBar(
    //       message: "Start time should be greater than current time.",
    //       duration: Duration(seconds: 2),
    //     ),
    //   );
    //   //  startTime == null;
    //   return;
    // }

    if (selectStartTime != null) {
      startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectStartTime!.hour,
        selectStartTime!.minute,
      );
    }

    _valueNotifier.notifyListeners();
  }

  ///  Service end time
  Widget _buildEndTime(BuildContext context) {
    return dateTextAndCalenderAndTimeIcon(
      onTap: _endTime,
      icon: ImgName.clock,
      context: context,
      date: endTime == null ? StaticString.endTime : formatTimeHM(endTime),
    );
  }

  Future<void> _endTime() async {
    selectedEndTime = await showTimePicker(
      context: getContext,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (selectedEndTime != null) {
      endTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedEndTime!.hour,
        selectedEndTime!.minute,
      );
    }

    _valueNotifier.notifyListeners();
    setState(() {});
  }

  Future<void> _confirm() async {
    if (startDate == null) {
      Get.showSnackbar(const GetSnackBar(
        message: "Date cannot be empty",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (startTime == null) {
      Get.showSnackbar(const GetSnackBar(
        message: "Start time cannot be empty",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (endTime == null) {
      Get.showSnackbar(const GetSnackBar(
        message: "End time cannot be empty",
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (startTime != null && endTime != null && startDate != null) {
      if (startTime!.isAfter(endTime!)) {
        Get.showSnackbar(
          const GetSnackBar(
            message: "End time cannot be before Start time",
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      Duration difference = endTime!.difference(
          startTime!); // calculate the duration between start and end
      double hours = difference.inMinutes / 60.0;
      if (hours > widget.offer.maxHours) {
        Get.showSnackbar(const GetSnackBar(
          message: "Logged hours cannot be more than maximum hours",
          duration: Duration(seconds: 2),
        ));
        return;
      }
      if (widget.offer.serviceId == null) {
        Get.showSnackbar(const GetSnackBar(
          message: "Error fetching service",
          duration: Duration(seconds: 2),
        ));
        return;
      }
      if (widget.offer.serviceId != null)
        jobOfferController.loggHours(context, widget.offer, startDate!,
            startTime!, endTime!, widget.offer.serviceId!);
    }
  }
}
