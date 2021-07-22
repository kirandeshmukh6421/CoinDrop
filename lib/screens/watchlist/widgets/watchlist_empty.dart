import 'package:coindrop/shared/constants.dart';
import 'package:flutter/material.dart';

class WatchlistEmpty extends StatelessWidget {
  final String asset;
  const WatchlistEmpty(this.asset);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: kMediumGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Track your favorite $asset',
              style: kEmptyTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Add your favorite $asset from the Markets Tab',
              style: kEmptySubTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Icon(
              Icons.addchart,
              color: kAccentColor,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
