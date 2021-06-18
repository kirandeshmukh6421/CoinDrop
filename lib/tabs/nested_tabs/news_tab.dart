import 'package:coindrop/screens/news/crypto_news.dart';
import 'package:coindrop/screens/news/stocks_news.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
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
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'STOCKS',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          // title: Text(kAppName),
          // centerTitle: true,
        ),
        body: TabBarView(
          children: [
            //now, we replace this to nested tab screen
            CryptoNews(),
            StocksNews(),
          ],
        ),
      ),
    );
  }
}
