import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingImages {
  static Widget getSvgImage(String assetName, BuildContext context, {double heightFactor = 0.29}) {
    return SvgPicture.asset(
      'assets/on-boarding-assets/$assetName',
      height: MediaQuery.of(context).size.height * heightFactor,
    );
  }

  static Widget freeIconsSvg(BuildContext context) {
    return getSvgImage('freeicons.io.svg', context);
  }

  static Widget appleFreeIconsSvg(BuildContext context) {
    return getSvgImage('apple-freeicons.io.svg', context);
  }

  static Widget freeFreeIconsSvg(BuildContext context) {
    return getSvgImage('free-freeicons.io.svg', context, heightFactor: 0.35);
  }
}
