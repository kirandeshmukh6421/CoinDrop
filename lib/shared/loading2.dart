import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'constants.dart';

class Loading2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkGrey,
      child: Center(
        child: SpinKitWave(
          color: kAccentColor,
          size: 25.0,
        ),
      ),
    );
  }
}
