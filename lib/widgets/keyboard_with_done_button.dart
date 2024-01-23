import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../constants/img_font_color_string.dart';
import '../widgets/custom_text.dart';

class KeyboardWithDoneButton extends StatelessWidget {
  /// List of focus node of all textfield which require done button...
  final List<FocusNode> focusNodeList;
  final Widget child;
  final bool showNextButton;
  final bool autoScroll;
  final bool disableScroll;
  final double overscroll;

  /// Click even when done is pressed...
  final void Function()? onDoneClicked;

  const KeyboardWithDoneButton({
    required this.focusNodeList,
    required this.child,
    required this.onDoneClicked,
    this.showNextButton = true,
    this.autoScroll = true,
    this.disableScroll = false,
    this.overscroll = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(color: Colors.white),
        disabledColor: Colors.white30,
      ),
      child: KeyboardActions(
        overscroll: overscroll,
        config: _buildConfig(context),
        child: child,
        autoScroll: autoScroll,
        disableScroll: disableScroll,
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      nextFocus: showNextButton,
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: cust5F5F5F,
      actions: focusNodeList
          .map(
            (node) => KeyboardActionsItem(
              toolbarButtons: [
                (node) {
                  return TextButton(
                    onPressed: onDoneClicked,
                    child: CustomText(
                      txtTitle: "Done",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  );
                }
              ],
              focusNode: node,
              onTapAction: onDoneClicked,
            ),
          )
          .toList(),
    );
  }
}
