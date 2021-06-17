import 'package:flutter/material.dart';

String kAppName = "Portfolio Tracker";
// Colors
Color kAccentColor = Colors.grey[600];
Color kDarkGrey = Colors.grey[900];
Color kMediumGrey = Color(0xFF242424);

// Text Styles
TextStyle kNewsTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w600,
  fontSize: 13,
);
TextStyle kListTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

TextStyle kListSubTextStyle = TextStyle(
  color: Colors.grey[600],
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w600,
  fontSize: 12,
);

TextStyle kPercentageTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
  fontSize: 14,
);

TextStyle kCurrentPriceTextStyle(var percentage) {
  return TextStyle(
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
    // Change color based on price movement.
    color: percentage > 0 ? Colors.green : Colors.red,
  );
}

Icon kUpArrow = Icon(
  Icons.arrow_upward,
  color: Colors.white,
  size: 15,
);

Icon kDownArrow = Icon(
  Icons.arrow_downward,
  color: Colors.white,
  size: 15,
);
