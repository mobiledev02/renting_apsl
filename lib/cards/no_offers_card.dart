import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class NoOffersCard extends StatelessWidget {
  const NoOffersCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 80,
          child: Center(
            child: CustomText(
              txtTitle: 'No Offers',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
