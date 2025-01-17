import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class settings_screen extends StatefulWidget {
  const settings_screen({super.key});

  @override
  _settings_screenState createState() => _settings_screenState();
}

class _settings_screenState extends State<settings_screen>
    with TickerProviderStateMixin {
  late GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    // Dispose the GifController to stop the Ticker
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .06),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mahmood Hafez',
                  style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).height * .04,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: MediaQuery.sizeOf(context).height * .03,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * .03,
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * .9,
          height: MediaQuery.sizeOf(context).height * .3,
          decoration: ShapeDecoration(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(33),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * .015),
                    child: Column(
                      children: [
                        AutoSizeText(
                          'Account \nSettings',
                          maxLines: 2,
                          minFontSize: 18,
                          maxFontSize: 40,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Kirang_Haerang',
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.sizeOf(context).height * .040,
                          ),
                        ),
                        Gif(
                          image: const AssetImage(
                            'assets/gif_for_setting/output-onlinegiftools (1).gif',
                          ),
                          height: MediaQuery.sizeOf(context).height * .18,
                          controller: _controller,
                          autostart: Autostart.loop,
                          placeholder: (context) => const Text('Loading...'),
                          onFetchCompleted: () {
                            if (_controller.isAnimating) {
                              _controller.stop();
                            }
                            _controller.reset();
                            _controller.forward();
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
