import 'dart:async';

import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/models/coin.dart';
import 'package:coindrop/screens/watchlist/widgets/coin_list.dart';
import 'package:coindrop/services/database/crypto_watchlist_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptoWatchlist extends StatefulWidget {
  @override
  _CryptoWatchlistState createState() => _CryptoWatchlistState();
}

class _CryptoWatchlistState extends State<CryptoWatchlist> {
  Timer timer;
  @override
  void initState() {
    super.initState();
    CoinWatchlistDatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .updateCoinData();
    timer = Timer.periodic(
        Duration(seconds: 10),
        (Timer t) => CoinWatchlistDatabaseService(
                uid: FirebaseAuth.instance.currentUser.uid)
            .updateCoinData());
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    CoinWatchlistDatabaseService(uid: user.uid).setDummyData();
    return StreamProvider<List<Coin>>.value(
      initialData: null,
      value: CoinWatchlistDatabaseService(uid: user.uid).coins,
      child: Container(
        child: Scaffold(
          backgroundColor: kMediumGrey,
          body: Container(
            child: CoinList(),
          ),
        ),
      ),
    );
  }
}
