import 'package:coindrop/shared/constants.dart';
import 'package:flutter/material.dart';

class PortfolioEmpty extends StatelessWidget {
  final String asset;
  const PortfolioEmpty(this.asset);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: kMediumGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your $asset portfolio is empty',
              style: kEmptyTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Buy your favorite $asset from the Markets Tab',
              style: kEmptySubTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Icon(
              Icons.add_shopping_cart,
              color: kAccentColor,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
