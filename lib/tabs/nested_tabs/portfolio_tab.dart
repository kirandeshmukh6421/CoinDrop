import 'package:coindrop/screens/portfolio/crypto_portfolio.dart';
import 'package:coindrop/screens/portfolio/stock_portfolio.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:flutter/material.dart';

class PortfolioTab extends StatefulWidget {
  @override
  _PortfolioTabState createState() => _PortfolioTabState();
}

class _PortfolioTabState extends State<PortfolioTab> {
  int currentPage = 1; // For switching tabs.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of Tabs.
      child: Scaffold(
        backgroundColor: kDarkGrey,
        appBar: AppBar(
          elevation: 1.5,
          toolbarHeight: kMinInteractiveDimension,
          bottom: TabBar(
            indicatorWeight: 3.0,
            labelPadding: EdgeInsets.all(10),
            tabs: [
              Text(
                'CRYPTO',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'STOCKS',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CryptoPortfolio(),
            StockPortfolio(),
          ],
        ),
      ),
    );
  }
}
