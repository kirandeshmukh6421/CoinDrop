import 'package:flutter/material.dart';

Text kAppName = Text(
  "CoinDrop",
  style: TextStyle(
    fontFamily: 'Pacifico',
    fontSize: 28,
  ),
);

Text kAppLogoName = Text(
  "CoinDrop",
  style: TextStyle(
    fontFamily: 'Pacifico',
    fontSize: 45,
    color: Colors.white,
  ),
);

// Colors
Color kAccentColor = Colors.grey[600];
Color kDarkGrey = Colors.grey[900];
Color kMediumGrey = Color(0xFF242424);

// Text Styles
TextStyle kEmptyTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
  fontSize: 13,
);

TextStyle kEmptySubTextStyle = TextStyle(
  color: kAccentColor,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w500,
  fontSize: 12,
);

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

const kTextInputDecoration = InputDecoration(
  border: InputBorder.none,
  contentPadding: EdgeInsets.only(top: 14.0),
);

final kBoxStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kHintStyle = TextStyle(
    color: Colors.blueGrey[900],
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w500);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
