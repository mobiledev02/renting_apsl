// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../widgets/spinner.dart';

enum LoadingStatus {
  Show,
  Hide,
}

enum LoadingIndicatorType {
  Overlay,
  Spinner,
}

class LoadingIndicator extends StatelessWidget {
  final Widget child;
  final LoadingIndicatorType indicatorType;
  final Color spinnerColor;
  final Widget? customLoadingIndicator;
  final ValueNotifier<LoadingStatus>? loadingStatusNotifier;

 const LoadingIndicator({Key? key, 
    required this.child,
    this.indicatorType = LoadingIndicatorType.Overlay,
    this.spinnerColor = Colors.white,
    this.loadingStatusNotifier,
    this.customLoadingIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LoadingStatus>(
      valueListenable: loadingStatusNotifier!,
      child: child,
      builder: (_, LoadingStatus value, Widget? builderChild) {
        Widget content;

        switch (indicatorType) {
          // Overlay...
          case LoadingIndicatorType.Overlay:
            List<Widget> children = [builderChild ?? Container()];

            if (value == LoadingStatus.Show) {
              children.add(loadingIndicator());
            }

            content = Stack(children: children);
            break;

          // Normal spinner...
          case LoadingIndicatorType.Spinner:
            content = value == LoadingStatus.Show
                ? customLoadingIndicator ??
                    Spinner(
                      progressColor: Theme.of(context).primaryColor,
                    )
                : builderChild!;
            break;
        }

        return content;
      },
    );
  }

  // Loading Indicator...
  Widget loadingIndicator() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black26,
      body: customLoadingIndicator ??
          Spinner(
            progressColor: spinnerColor,
          ),
    );
  }
}

//------ Loading Status Notifier ----//
class LoadingIndicatorNotifier extends ChangeNotifier {
  final ValueNotifier<LoadingStatus> _loadingStatus =
      ValueNotifier<LoadingStatus>(LoadingStatus.Hide);

  ValueNotifier<LoadingStatus> get statusNotifier => _loadingStatus;

  void show() {
    _loadingStatus.value = LoadingStatus.Show;
    notifyListeners();
  }

  void hide() {
    _loadingStatus.value = LoadingStatus.Hide;
    notifyListeners();
  }

  void disposeNotifier() {
    _loadingStatus.dispose();
  }
}
