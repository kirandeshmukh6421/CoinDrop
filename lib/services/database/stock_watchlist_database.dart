import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindrop/models/stock.dart';
import 'package:http/http.dart';

class StockWatchlistDatabaseService {
  final String uid;
  StockWatchlistDatabaseService({this.uid});

  // Get reference to 'watchlists' collection.
  CollectionReference watchlistCollection =
      FirebaseFirestore.instance.collection('watchlists');

  // Convert QuerySnapshot to Stock List.
  List<Stock> _coinListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Stock(
        name: doc.get('name').toString() ?? '',
        ticker: doc.get('ticker').toString() ?? '',
        currentPrice: double.parse(doc.get('currentPrice').toString()) ?? 0.0,
        high: double.parse(doc.get('high').toString()) ?? 0.0,
        low: double.parse(doc.get('low').toString()) ?? 0.0,
        open: double.parse(doc.get('open').toString()) ?? 0.0,
        percentage: double.parse(doc.get('percentage').toString()) ?? 0.0,
        volume: double.parse(doc.get('volume').toString()) ?? 0.0,
        high52: double.parse(doc.get('high52').toString()) ?? 0.0,
        low52: double.parse(doc.get('low52').toString()) ?? 0.0,
        closeyest: double.parse(doc.get('closeyest').toString()) ?? 0.0,
        eps: double.parse(doc.get('eps').toString()) ?? 0.0,
        marketcap: double.parse(doc.get('marketcap').toString()) ?? 0.0,
        pe: double.parse(doc.get('pe').toString()) ?? 0.0,
      );
    }).toList();
  }

  // Add Stock to Watchlist
  Future addStock({
    String ticker,
    String name,
    num currentPrice,
    num percentage,
    var low,
    var high,
    var open,
    var volume,
    var closeyest,
    var high52,
    var low52,
    var marketcap,
    var pe,
    var eps,
  }) async {
    return await FirebaseFirestore.instance
        .doc('/watchlists/$uid/stocks/$ticker')
        .set({
      'ticker': ticker,
      'name': name,
      'currentPrice': currentPrice,
      'open': open,
      'high': high,
      'low': low,
      'percentage': percentage,
      'volume': volume,
      'closeyest': closeyest,
      'high52': high52,
      'low52': low52,
      'pe': pe,
      'eps': eps,
      'marketcap': marketcap
    });
  }

  // Remove Stock from Watchlist
  void removeStock(String ticker) {
    watchlistCollection
        .doc(uid.toString())
        .collection('stocks')
        .doc(ticker)
        .delete()
        .catchError((error) => print('Delete failed: $error'));
  }

  // Refresh Stock Data in Watchlist
  Future updateStockData() async {
    var stockUrl = Uri.parse(
        'https://script.googleusercontent.com/macros/echo?user_content_key=jlAJqgmRrk_0p7ODOXHeHgseSdYjC6fSUTsriqcj5GNxcPXxCjyknRS-D3wfhCI3RNGcdkB31r_Ck9qGyK5HdFAUR19YEf28m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnJYKFJ7HW08Z9F7G3-XP7bFrRvJhxX-PFNDTzAbojsZLQHLeTE0sbdOTQtse5ov4jx9YTvSkEsla6GMq52XJUZNRqM7RMRhLCg&lib=MBwU-wX6Djp4dKG66FJCLjijdirNHEf7t');
    // Send HTTP GET request to fetch stock data.
    Response response = await get(stockUrl);
    if (response.statusCode == 200) {
      // Store data in a Map
      Map data = jsonDecode(response.body);
      var snapshots =
          await watchlistCollection.doc(uid).collection('stocks').get();
      // Loop through all Stocks in Watchlist and update.
      for (var stock in snapshots.docs) {
        String docTicker = stock.id.toString();
        String ticker = data[docTicker.toString().toUpperCase()]["ticker"];
        String name = data[docTicker.toString().toUpperCase()]["name"];
        num currentPrice = double.parse(
            data[docTicker.toString().toUpperCase()]["price"].toString());
        num high = double.parse(
            data[docTicker.toString().toUpperCase()]["high"].toString());
        num low = double.parse(
            data[docTicker.toString().toUpperCase()]["low"].toString());
        num open = double.parse(
            data[docTicker.toString().toUpperCase()]["open"].toString());
        num volume = double.parse(
            data[docTicker.toString().toUpperCase()]["volume"].toString());
        num percentage = double.parse(
            data[docTicker.toString().toUpperCase()]["change"].toString());
        num high52 = double.parse(
            data[docTicker.toString().toUpperCase()]["high52"].toString());
        num low52 = double.parse(
            data[docTicker.toString().toUpperCase()]["low52"].toString());
        num pe = double.parse(
            data[docTicker.toString().toUpperCase()]["pe"].toString());
        num eps = double.parse(
            data[docTicker.toString().toUpperCase()]["eps"].toString());
        num marketcap = double.parse(
            data[docTicker.toString().toUpperCase()]["marketcap"].toString());
        num closeyest = double.parse(
            data[docTicker.toString().toUpperCase()]["closeyest"].toString());
        await FirebaseFirestore.instance
            .doc('/watchlists/$uid/stocks/$docTicker')
            .update({
          'ticker': ticker,
          'name': name,
          'currentPrice': currentPrice,
          'open': open,
          'high': high,
          'low': low,
          'percentage': percentage,
          'volume': volume,
          'closeyest': closeyest,
          'high52': high52,
          'low52': low52,
          'pe': pe,
          'eps': eps,
          'marketcap': marketcap
        });
      }
    }
  }

  // This stream notifies the Provider package of the updates in the database.
  Stream<List<Stock>> get stocks {
    return watchlistCollection
        .doc(uid)
        .collection('stocks')
        .snapshots()
        .map(_coinListFromSnapshot);
  }

  Future setDummyData() async {
    return await FirebaseFirestore.instance
        .doc('/watchlists/$uid')
        .set({'uid': uid});
  }
}
