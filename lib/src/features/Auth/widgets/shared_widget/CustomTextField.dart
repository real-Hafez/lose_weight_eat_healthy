import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/shared/CustomStyles.dart';

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
          checkUsernameAvailability(_controller.text.trim());
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

  Future<void> checkUsernameAvailability(String username) async {
    if (username.isEmpty) return;

    setState(() {
      isChecking = true;
    });

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      setState(() {
        isUsernameTaken = result.docs.isNotEmpty;
        isChecking = false;
      });
    } catch (e) {
      setState(() {
        isUsernameTaken = false;
        isChecking = false;
      });
    }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .006),
          Padding(
            padding: const EdgeInsets.only(left: 10),
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
                onTogglePasswordVisibility:
                    widget.isPassword ? _togglePasswordVisibility : null,
              ),
            ),
          ),
          if (isUsernameTaken && widget.label == 'Username')
            const Padding(
              padding: EdgeInsets.only(top: 5, left: 5),
              child: Text(
                'Username is already taken',
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (isChecking && widget.label == 'Username')
            const Padding(
              padding: EdgeInsets.only(top: 5, left: 5),
            ),
        ],
      ),
    );
  }
}
