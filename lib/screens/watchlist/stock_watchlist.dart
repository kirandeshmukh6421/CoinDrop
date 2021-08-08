import 'dart:async';

import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/models/stock.dart';
import 'package:coindrop/screens/watchlist/widgets/stock_list.dart';
import 'package:coindrop/services/database/stock_watchlist_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockWatchlist extends StatefulWidget {
  @override
  _StockWatchlistState createState() => _StockWatchlistState();
}

class _StockWatchlistState extends State<StockWatchlist> {
  Timer timer;
  @override
  void initState() {
    super.initState();
    StockWatchlistDatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .updateStockData();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    StockWatchlistDatabaseService(uid: user.uid).setDummyData();
    return StreamProvider<List<Stock>>.value(
      initialData: null,
      value: StockWatchlistDatabaseService(uid: user.uid).stocks,
      child: Container(
        child: Scaffold(
          backgroundColor: kMediumGrey,
          body: Container(
            child: StockList(),
          ),
        ),
      ),
    );
  }
}
