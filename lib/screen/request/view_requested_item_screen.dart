import 'package:flutter/material.dart';

import '/widgets/custom_appbar.dart';
import '/widgets/custom_calendar.dart';
import '../../constants/img_font_color_string.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/custom_text.dart';

class ViewRequestedItemScreen extends StatelessWidget {
  const ViewRequestedItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  final DateFormat formatter = DateFormat("d MMMM, y");
    // final String formattedDate = formatter.format();

    return Scaffold(
      appBar: CustomAppbar(
        title: "Item Name",
      ),
      // appBar: _buildAppbar(title: "Item Name"),-
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 30,
              ),

              /// Someone in your area wants to borrow an item! Text
              _buildSomeoneText(context),
              const SizedBox(
                height: 12,
              ),

              /// Need it by Text And Date
              _buildNeedItByAndDate(context),

              const SizedBox(
                height: 8,
              ),
              //  calender
              const CustomCalendarView(),
            ],
          ),
        ),
      ),
    );
  }

//!-------------------------- Widget ---------------------

  ///  Appbar
  AppBar _buildAppbar({required String title}) {
    return AppBar(
      centerTitle: false,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustBackButton(),
        ],
      ),
      title: CustomText(
        txtTitle: title, // item Name
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Someone in your area wants to borrow an item! Text
  Widget _buildSomeoneText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 29,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomText(
        align: TextAlign.center,
        txtTitle: StaticString.someoneInYourAreaWantsToBorrowAnItem,
        //Someone in your area wants to borrow an item!
        style: Theme.of(context).textTheme.headline2?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  /// Need it by Text And Date
  Widget _buildNeedItByAndDate(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          txtTitle: StaticString.needItby, //Need it by
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),

        // date
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 19,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromRGBO(16, 35, 57, 0.1),
                width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomText(
            txtTitle: "05/10/2020", // date
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
