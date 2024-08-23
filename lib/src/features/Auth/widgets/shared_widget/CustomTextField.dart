import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/service/username_service.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/signup_widgets/UsernameErrorText.dart';
import 'package:lose_weight_eat_healthy/src/shared/CustomStyles.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Size size;
  final bool hasError;
  final bool isRequired;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.size = const Size(double.infinity, 50),
    this.hasError = false,
    this.isRequired = false,
    this.onChanged,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();
  bool isUsernameTaken = false;
  bool isChecking = false;
  bool hasStartedTyping = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(() {
      if (widget.label == 'Username') {
        if (_controller.text.isNotEmpty) {
          setState(() {
            hasStartedTyping = true;
          });
          checkUsernameAvailability(_controller.text.trim()).then((isTaken) {
            setState(() {
              isUsernameTaken = isTaken;
            });
          });
        } else {
          setState(() {
            hasStartedTyping = false;
            isUsernameTaken = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .006,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * .02,
              right: isarabic() ? MediaQuery.of(context).size.height * .02 : 0,
            ),
            child: Row(
              children: [
                Text(
                  widget.label,
                  style: CustomStyles.labelStyle(context, widget.hasError),
                ),
                if (widget.isRequired)
                  Text(
                    ' *',
                    style: CustomStyles.requiredMarkStyle(context),
                  ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .005),
          SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * .004,
                right: MediaQuery.of(context).size.height * .004,
              ),
              child: TextField(
                controller: _controller,
                keyboardType: widget.keyboardType,
                obscureText: widget.isPassword ? _obscureText : false,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                decoration: CustomStyles.inputDecoration(
                  hintText: widget.hintText,
                  hasError: widget.hasError,
                  isPassword: widget.isPassword,
                  isChecking: isChecking,
                  hasStartedTyping: hasStartedTyping,
                  isUsernameTaken: isUsernameTaken,
                  isObscureText: _obscureText,
                  onTogglePasswordVisibility: widget.isPassword
                      ? () => _togglePasswordVisibility()
                      : null,
                ),
              ),
            ),
          ),
          if (widget.label == 'Username')
            UsernameErrorText(isUsernameTaken: isUsernameTaken),
        ],
      ),
    );
  }
}

bool isarabic() {
  return Intl.getCurrentLocale() == 'ar';
}
