import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../constants/img_font_color_string.dart';

class TimerWidget extends StatefulWidget {
  final AsyncCallback function;

  const TimerWidget({Key? key, required this.function}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _time = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_time == 0) {
        _timer?.cancel();
      } else {
        setState(() {
          _time--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 15,
        ),
        if (_time == 0)
          RichText(
            text: TextSpan(
              style: const TextStyle(color: custGrey7E7E7E),
              text: "Didn't receive OTP? ",
              children: [
                TextSpan(
                  style: const TextStyle(color: primaryColor),
                  text: "Resend OTP",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      widget.function();
                      setState(() {
                        _time = 10;
                      });
                      startTimer();
                    },
                )
              ],
            ),
          )
        else
          RichText(
            text: TextSpan(
              style: const TextStyle(color: custGrey7E7E7E),
              text: "Didn't receive OTP? ",
              children: [
                const TextSpan(
                  text: "",
                ),
                TextSpan(
                  text: " $_time",
                )
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
