import 'package:flutter/material.dart';
import 'package:renting_app_mobile/widgets/cust_button.dart';


void showAllowYourLocationDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => const AllowYourLocationDialog());

}

class AllowYourLocationDialog extends StatelessWidget {
  const AllowYourLocationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog (
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/location_art.png'),
          const Text('Allow your location'),
            const Text('We will need your location to give you batter experience.'),
            CustomButton(onPressed: () {}, child: const Text('Allow Location'),),
            const Text('Maybe Later'),
          ],
      ),
    );
  }
}
