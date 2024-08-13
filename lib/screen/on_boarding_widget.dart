import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class on_boarding_widget extends StatelessWidget {
  const on_boarding_widget({
    super.key,
    required this.main_title,
    required this.sub_title,
    required this.icon,
  });

  final String main_title;
  final String sub_title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .013,
        ),
        Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * .013,
          ),
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * .08,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width *
              .035, // Space between icon and text
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * .02),
                child: AutoSizeText(
                  main_title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * .23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width *
                    .005,
              ),
              AutoSizeText(
                sub_title,
                maxLines: 2,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * .021,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
