import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _controller = widget.controller ?? TextEditingController();

    // Attach the onChanged function to the controller to listen for changes.
    _controller.addListener(() {
      if (widget.label == 'Username') {
        checkUsernameAvailability(_controller.text.trim());
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .006,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * .02,
                    color: widget.hasError ? Colors.red : Colors.white,
                  ),
                ),
                if (widget.isRequired)
                  Text(
                    ' *',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * .02,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .005,
          ),
          SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: TextField(
              controller: _controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword ? _obscureText : false,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 10.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          widget.hasError ? Colors.red : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(22),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          widget.hasError ? Colors.red : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: widget.label == 'Username'
                    ? isChecking
                        ? const CircularProgressIndicator()
                        : isUsernameTaken
                            ? const Icon(Icons.close, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green)
                    : widget.isPassword
                        ? IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          )
                        : null,
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
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
