import 'package:coindrop/models/coin.dart';
import 'package:coindrop/screens/watchlist/widgets/coin_tile.dart';
import 'package:coindrop/screens/watchlist/widgets/watchlist_empty.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinList extends StatefulWidget {
  @override
  _CoinListState createState() => _CoinListState();
}

class _CoinListState extends State<CoinList> {
  @override
  Widget build(BuildContext context) {
    final coins = Provider.of<List<Coin>>(context) ?? [];
    return coins.isNotEmpty
        ? ListView.builder(
            itemCount: coins.length,
            itemBuilder: (context, index) {
              return CoinTile(coin: coins[index]);
            },
          )
        : WatchlistEmpty('crypto');
  }
}
