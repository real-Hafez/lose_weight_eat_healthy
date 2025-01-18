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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mahmood Hafez',
                      style: TextStyle(
                        fontSize: height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(height * 0.02),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontSize: height * 0.04,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Gif(
                        image: const AssetImage(
                          'assets/gif_for_setting/output-onlinegiftools (1).gif',
                        ),
                        height: height * 0.16,
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
                  // SizedBox(width: width * 0.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _settingsText('Profile Information', Icons.person),
                        _divider(),
                        _settingsText('Password Management', Icons.lock),
                        _divider(),
                        _settingsText('Privacy Controls', Icons.privacy_tip),
                        _divider(),
                        _settingsText('Connected Accounts', Icons.link),
                        _divider(),
                        _settingsText(
                            'Subscription Management', Icons.subscriptions),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsText(String text, IconData leadingIcon) {
    return GestureDetector(
      onTap: () {
        print('Settings  $text');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              leadingIcon,
              color: Colors.white,
              size: MediaQuery.of(context).size.height * 0.025,
            ),
            SizedBox(width: 10),
            Expanded(
              child: AutoSizeText(
                text,
                maxLines: 1,
                minFontSize: 22,
                maxFontSize: 32,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Kirang_Haerang',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.white70,
    );
  }
}
