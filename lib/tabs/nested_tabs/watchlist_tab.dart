import 'package:coindrop/screens/watchlist/crypto_watchlist.dart';
import 'package:coindrop/screens/watchlist/stock_watchlist.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class WatchlistTab extends StatefulWidget {
  @override
  _WatchlistTabState createState() => _WatchlistTabState();
}

class _WatchlistTabState extends State<WatchlistTab> {
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
            CryptoWatchlist(),
            StockWatchlist(),
          ],
        ),
      ),
    );
  }
}
