
import 'package:flutter/material.dart';

import '../widgets/spinner.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: Spinner(),
    ),
  );
}
