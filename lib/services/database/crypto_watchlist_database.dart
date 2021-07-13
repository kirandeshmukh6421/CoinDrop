import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindrop/models/coin.dart';
import 'package:http/http.dart';

class CoinWatchlistDatabaseService {
  final String uid;
  CoinWatchlistDatabaseService({this.uid});

  // Get reference to 'watchlists' collection.
  CollectionReference watchlistCollection =
      FirebaseFirestore.instance.collection('watchlists');

  // Convert QuerySnapshot to Coin List.
  List<Coin> _coinListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Coin(
        name: doc.get('name').toString() ?? '',
        ticker: doc.get('ticker').toString() ?? '',
        currentPrice: double.parse(doc.get('currentPrice').toString()) ?? 0.0,
        high: double.parse(doc.get('high').toString()) ?? 0.0,
        low: double.parse(doc.get('low').toString()) ?? 0.0,
        open: double.parse(doc.get('open').toString()) ?? 0.0,
        percentage: double.parse(doc.get('percentage').toString()) ?? 0.0,
        volume: double.parse(doc.get('volume').toString()) ?? 0.0,
        buy: double.parse(doc.get('buy').toString()) ?? 0.0,
        sell: double.parse(doc.get('sell').toString()) ?? 0.0,
      );
    }).toList();
  }

  // Add Coin to Watchlist
  Future addCoin(
    String ticker,
    String name,
    double currentPrice,
    double open,
    double high,
    double low,
    double percentage,
    double volume,
    double buy,
    double sell,
  ) async {
    return await FirebaseFirestore.instance
        .doc('/watchlists/$uid/crypto/$ticker')
        .set({
      'ticker': ticker,
      'name': name,
      'currentPrice': currentPrice,
      'open': open,
      'high': high,
      'low': low,
      'percentage': percentage,
      'volume': volume,
      'buy': buy,
      'sell': sell
    });
  }

  // Remove Coin from Watchlist
  void removeCoin(String ticker) {
    watchlistCollection
        .doc(uid.toString())
        .collection('crypto')
        .doc(ticker)
        .delete()
        .catchError((error) => print('Delete failed: $error'));
  }

  // Refresh Coin Data in Watchlist
  Future updateCoinData() async {
    var coinUrl = Uri.parse('https://api.wazirx.com/api/v2/tickers');
    // Send HTTP GET request to fetch coin data.
    Response response = await get(coinUrl);
    if (response.statusCode == 200) {
      // Store data in a Map
      Map data = jsonDecode(response.body);
      var snapshots =
          await watchlistCollection.doc(uid).collection('crypto').get();
      // Loop through all Coins in Watchlist and update.
      for (var coin in snapshots.docs) {
        String docTicker = coin.id.toString();
        String ticker =
            data[docTicker.toString().toLowerCase() + "inr"]["base_unit"];
        double currentPrice = double.parse(
            data[docTicker.toString().toLowerCase() + "inr"]["last"]
                .toString());
        double high = double.parse(
            data[docTicker.toString().toLowerCase() + "inr"]["high"]
                .toString());
        double low = double.parse(
            data[docTicker.toString().toLowerCase() + "inr"]["low"].toString());
        double open = double.parse(
            data[docTicker.toString().toLowerCase() + "inr"]["open"]
                .toString());
        double percentage = (double.parse(currentPrice.toString()) -
                double.parse(open.toString())) /
            double.parse(open.toString());
        double volume = double.parse(
            data[docTicker.toString().toLowerCase() + "inr"]["volume"]
                .toString());
        double buy = double.parse(
            data[docTicker.toString().toLowerCase() + "inr"]["buy"].toString());
        double sell = double.parse(
            data[docTicker.toString().toLowerCase() + "inr"]["sell"]
                .toString());
        await FirebaseFirestore.instance
            .doc('/watchlists/$uid/crypto/$docTicker')
            .update({
          'ticker': ticker.toString().toUpperCase(),
          'currentPrice': currentPrice,
          'open': open,
          'high': high,
          'low': low,
          'percentage': percentage * 100,
          'volume': volume,
          'buy': buy,
          'sell': sell
        });
      }
    }
  }

  // This stream notifies the Provider package of the updates in the database.
  Stream<List<Coin>> get coins {
    return watchlistCollection
        .doc(uid)
        .collection('crypto')
        .snapshots()
        .map(_coinListFromSnapshot);
  }

  Future setDummyData() async {
    return await FirebaseFirestore.instance
        .doc('/watchlists/$uid')
        .set({'uid': uid});
  }
}
