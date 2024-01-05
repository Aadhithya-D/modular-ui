import 'package:flutter/material.dart';
import 'package:modular_ui/src/utils/dimensions.dart';

class MUILoadingButton extends StatefulWidget {
  /// Text for Loading Button
  final String text;

  /// Future Function to be passed, must be a awaited
  final Future Function() onPressed;

  /// Text to be shown when widget is in loading state, empty string by default
  final String loadingStateText;

  /// Background color of loading button
  final Color bgColor;

  /// Text color of loading button
  final Color textColor;

  /// Background Color when button is in loading state
  final Color loadingStateBackgroundColor;

  /// Text Color when button is in loading state
  final Color loadingStateTextColor;

  /// Border radius, default value is 10
  final double borderRadius;

  /// Animation duration in milliseconds, default value is 250ms
  final int animationDuraton;

  /// Enables light haptic feedback
  final bool hapticsEnabled;

  /// A double value which gets multiplied by the current screen width when button is not pressed
  final double widthFactorUnpressed;

  /// A double value which gets multiplied by the current screen width when button is pressed
  final double widthFactorPressed;

  /// A double value which gets multiplied by the current screen height when button is  pressed
  final double heightFactorPressed;

  /// A double value which gets multiplied by the current screen height when button is not pressed
  final double heightFactorUnPressed;
  const MUILoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loadingStateText = '',
    this.bgColor = Colors.black,
    this.textColor = Colors.white,
    this.loadingStateBackgroundColor = Colors.grey,
    this.loadingStateTextColor = Colors.white,
    this.borderRadius = 10,
    this.animationDuraton = 250,
    this.hapticsEnabled = false,
    this.widthFactorUnpressed = 0.04,
    this.widthFactorPressed = 0.035,
    this.heightFactorUnPressed = 0.03,
    this.heightFactorPressed = 0.025,
  });

  @override
  State<MUILoadingButton> createState() => _MUILoadingButtonState();
}

class _MUILoadingButtonState extends State<MUILoadingButton> {
  bool _isLoadingButtonPressed = false;

  void _startLoading() {
    setState(() {
      _isLoadingButtonPressed = true;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoadingButtonPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) async {
        _startLoading();
        try {
          await widget.onPressed();
        } finally {
          _stopLoading();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDuraton),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: !_isLoadingButtonPressed
              ? widget.bgColor
              : widget.loadingStateBackgroundColor,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: _isLoadingButtonPressed
              ? getScreenWidth(context) * widget.widthFactorPressed
              : getScreenWidth(context) * widget.widthFactorUnpressed,
          vertical: _isLoadingButtonPressed
              ? getScreenWidth(context) * widget.heightFactorPressed
              : getScreenWidth(context) * widget.heightFactorUnPressed,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          child: !_isLoadingButtonPressed
              ? Text(
                  widget.text,
                  style: TextStyle(color: widget.textColor),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: getScreenWidth(context) * 0.02),
                      width: getScreenWidth(context) * 0.04,
                      height: getScreenWidth(context) * 0.04,
                      child: CircularProgressIndicator(
                        color: widget.loadingStateTextColor,
                      ),
                    ),
                    Text(
                      widget.loadingStateText,
                      style: TextStyle(color: widget.loadingStateTextColor),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
