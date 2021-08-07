import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindrop/models/asset.dart';
import 'package:http/http.dart';

class StockPortfolioDatabaseService {
  final String uid;
  StockPortfolioDatabaseService({this.uid});

  // Get reference to 'portfolios' collection.
  CollectionReference portfolioCollection =
      FirebaseFirestore.instance.collection('portfolios');

  List<Stocks> _stockListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Stocks(
        ticker: doc.get('ticker').toString() ?? '',
        name: doc.get('name').toString() ?? '',
        currentValue: double.parse(doc.get('currentValue').toString()) ?? 0.0,
        quantity: int.parse(doc.get('quantity').toString()) ?? 0,
        invested: double.parse(doc.get('invested').toString()) ?? 0.0,
        profit: double.parse(doc.get('profit').toString()) ?? 0.0,
        percentage: double.parse(doc.get('percentage').toString()) ?? 0.0,
      );
    }).toList();
  }

  // Buy Stock and add to Portfolio
  Future buyStock({
    String ticker,
    String name,
    double currentValue,
    double percentage,
    double invested,
    int quantity,
    double profit,
  }) async {
    return await FirebaseFirestore.instance
        .doc('/portfolios/$uid/stocks/$ticker')
        .set({
      'ticker': ticker,
      'name': name,
      'quantity': quantity,
      'currentValue': currentValue,
      'invested': invested,
      'profit': profit,
      'percentage': percentage,
    });
  }

  // Buy more of existing Stock
  Future partialBuy(
      {String ticker, int quantity, double price, double invested}) async {
    DocumentSnapshot doc = await portfolioCollection
        .doc(uid)
        .collection('stocks')
        .doc(ticker)
        .get();
    int oldQuantity = doc.get("quantity");
    double oldInvested = doc.get("invested");
    return await portfolioCollection.doc('$uid/stocks/$ticker').update({
      "quantity": quantity + oldQuantity,
      "invested": invested + oldInvested,
    });
  }

  Future sellStock(
      {String ticker, int quantity, double price, double invested}) async {
    DocumentSnapshot doc = await portfolioCollection
        .doc(uid)
        .collection('stocks')
        .doc(ticker)
        .get();
    int oldQuantity = doc.get("quantity");
    double oldInvested = doc.get("invested");
    if (quantity == oldQuantity) {
      portfolioCollection
          .doc(uid.toString())
          .collection('stocks')
          .doc(ticker)
          .delete()
          .catchError((error) => print('Delete failed: $error'));
    } else
      return await portfolioCollection.doc('$uid/stocks/$ticker').update({
        "quantity": oldQuantity - quantity,
        "invested": oldInvested - invested,
      });
  }

  // Update Total Invested
  Future updateTotalInvested() async {
    double total = 0;
    var snapshots =
        await portfolioCollection.doc(uid).collection('stocks').get();
    for (var stock in snapshots.docs) {
      String docTicker = stock.id.toString();
      DocumentSnapshot doc = await portfolioCollection
          .doc(uid)
          .collection('stocks')
          .doc(docTicker)
          .get();
      double stocksInvested = doc.get("invested");
      total += stocksInvested;
    }
    portfolioCollection.doc(uid).update({
      "stocksInvested": total,
    });
  }

  // Update Current Value
  Future updateCurrentValue() async {
    double total = 0;
    var snapshots =
        await portfolioCollection.doc(uid).collection('stocks').get();
    for (var stock in snapshots.docs) {
      String docTicker = stock.id.toString();
      DocumentSnapshot doc = await portfolioCollection
          .doc(uid)
          .collection('stocks')
          .doc(docTicker)
          .get();
      double currentValue = doc.get("currentValue");
      total += currentValue;
    }
    portfolioCollection.doc(uid).update({
      "currentStocksValue": total,
    });
  }

  // Refresh Portfolio
  Future updatePortfolio() async {
    var stockUrl = Uri.parse(
        'https://script.googleusercontent.com/macros/echo?user_content_key=jlAJqgmRrk_0p7ODOXHeHgseSdYjC6fSUTsriqcj5GNxcPXxCjyknRS-D3wfhCI3RNGcdkB31r_Ck9qGyK5HdFAUR19YEf28m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnJYKFJ7HW08Z9F7G3-XP7bFrRvJhxX-PFNDTzAbojsZLQHLeTE0sbdOTQtse5ov4jx9YTvSkEsla6GMq52XJUZNRqM7RMRhLCg&lib=MBwU-wX6Djp4dKG66FJCLjijdirNHEf7t');
    // Send HTTP GET request to fetch stock data.
    Response response = await get(stockUrl);
    if (response.statusCode == 200) {
      // Store data in a Map
      Map data = jsonDecode(response.body);
      var snapshots =
          await portfolioCollection.doc(uid).collection('stocks').get();
      // Loop through all Stocks in Watchlist and update.
      for (var stock in snapshots.docs) {
        String docTicker = stock.id.toString();
        num currentPrice = double.parse(
            data[docTicker.toString().toUpperCase()]["price"].toString());
        DocumentSnapshot doc = await portfolioCollection
            .doc(uid)
            .collection('stocks')
            .doc(docTicker)
            .get();
        int quantity = doc.get("quantity");
        double invested = doc.get("invested");
        double currentValue = quantity * currentPrice;
        double profit = currentValue - invested;
        double percentage = (profit / invested) * 100;
        await portfolioCollection
            .doc(uid)
            .collection('stocks')
            .doc(docTicker)
            .update({
          "currentValue": currentValue,
          "profit": profit,
          "percentage": percentage,
        });
      }
    }
  }

  // Check if stock exists in Portfolio
  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await portfolioCollection
          .doc(uid)
          .collection('stocks')
          .doc(docId)
          .get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  // This stream notifies the Provider package of the updates in the database.
  Stream<List<Stocks>> get stocks {
    return portfolioCollection
        .doc(uid)
        .collection('stocks')
        .snapshots()
        .map(_stockListFromSnapshot);
  }
}
