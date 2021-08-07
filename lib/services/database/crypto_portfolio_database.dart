import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindrop/models/asset.dart';
import 'package:http/http.dart';

class CryptoPortfolioDatabaseService {
  final String uid;
  CryptoPortfolioDatabaseService({this.uid});

  // Get reference to 'portfolios' collection.
  CollectionReference portfolioCollection =
      FirebaseFirestore.instance.collection('portfolios');

  List<Crypto> _coinListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Crypto(
        ticker: doc.get('ticker').toString() ?? '',
        name: doc.get('name').toString() ?? '',
        currentValue: double.parse(doc.get('currentValue').toString()) ?? 0.0,
        quantity: double.parse(doc.get('quantity').toString()) ?? 0.0,
        invested: double.parse(doc.get('invested').toString()) ?? 0.0,
        profit: double.parse(doc.get('profit').toString()) ?? 0.0,
        percentage: double.parse(doc.get('percentage').toString()) ?? 0.0,
      );
    }).toList();
  }

  // Buy Coin and add to Portfolio
  Future buyCoin({
    String ticker,
    String name,
    double currentValue,
    double percentage,
    double invested,
    double quantity,
    double profit,
  }) async {
    return await FirebaseFirestore.instance
        .doc('/portfolios/$uid/crypto/$ticker')
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

  // Buy more of existing Crypto
  Future partialBuy(
      {String ticker, double quantity, double price, double invested}) async {
    DocumentSnapshot doc = await portfolioCollection
        .doc(uid)
        .collection('crypto')
        .doc(ticker)
        .get();
    double oldQuantity = doc.get("quantity");
    double oldInvested = doc.get("invested");
    return await portfolioCollection.doc('$uid/crypto/$ticker').update({
      "quantity": quantity + oldQuantity,
      "invested": invested + oldInvested,
    });
  }

  Future sellCoin(
      {String ticker, double quantity, double price, double invested}) async {
    DocumentSnapshot doc = await portfolioCollection
        .doc(uid)
        .collection('crypto')
        .doc(ticker)
        .get();
    double oldQuantity = doc.get("quantity");
    double oldInvested = doc.get("invested");
    if (quantity == oldQuantity) {
      portfolioCollection
          .doc(uid.toString())
          .collection('crypto')
          .doc(ticker)
          .delete()
          .catchError((error) => print('Delete failed: $error'));
    } else
      return await portfolioCollection.doc('$uid/crypto/$ticker').update({
        "quantity": oldQuantity - quantity,
        "invested": oldInvested - invested,
      });
  }

  // Update Total Invested
  Future updateTotalInvested() async {
    double total = 0;
    var snapshots =
        await portfolioCollection.doc(uid).collection('crypto').get();
    for (var coin in snapshots.docs) {
      String docTicker = coin.id.toString();
      DocumentSnapshot doc = await portfolioCollection
          .doc(uid)
          .collection('crypto')
          .doc(docTicker)
          .get();
      double cryptoInvested = doc.get("invested");
      total += cryptoInvested;
    }
    portfolioCollection.doc(uid).update({
      "cryptoInvested": total,
    });
  }

  // Update Current Value
  Future updateCurrentValue() async {
    double total = 0;
    var snapshots =
        await portfolioCollection.doc(uid).collection('crypto').get();
    for (var coin in snapshots.docs) {
      String docTicker = coin.id.toString();
      DocumentSnapshot doc = await portfolioCollection
          .doc(uid)
          .collection('crypto')
          .doc(docTicker)
          .get();
      double currentValue = doc.get("currentValue");
      total += currentValue;
    }
    portfolioCollection.doc(uid).update({
      "currentCryptoValue": total,
    });
  }

  // Refresh Portfolio
  Future updatePortfolio() async {
    var coinUrl = Uri.parse('https://api.wazirx.com/api/v2/tickers');
    // Send HTTP GET request to fetch coin data.
    Response response = await get(coinUrl);
    if (response.statusCode == 200) {
      // Store data in a Map
      Map data = jsonDecode(response.body);
      var snapshots =
          await portfolioCollection.doc(uid).collection('crypto').get();
      // Loop through all Coins in Portfolio and update.
      for (var coin in snapshots.docs) {
        String docTicker = coin.id.toString();
        double currentPrice = double.parse(
            data[docTicker.toString().toLowerCase() + "inr"]["last"]
                .toString());
        DocumentSnapshot doc = await portfolioCollection
            .doc(uid)
            .collection('crypto')
            .doc(docTicker)
            .get();
        double quantity = doc.get("quantity");
        double invested = doc.get("invested");
        double currentValue = quantity * currentPrice;
        double profit = currentValue - invested;
        double percentage = (profit / invested) * 100;
        await portfolioCollection
            .doc(uid)
            .collection('crypto')
            .doc(docTicker)
            .update({
          "currentValue": currentValue,
          "profit": profit,
          "percentage": percentage,
        });
      }
    }
  }

  // Check if coin exists in Portfolio
  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await portfolioCollection
          .doc(uid)
          .collection('crypto')
          .doc(docId)
          .get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  // Set Initial Data
  Future setInitialData() async {
    portfolioCollection.doc(uid).set({
      "cryptoInvested": 0.0,
      "currentCryptoValue": 0.0,
      "stocksInvested": 0.0,
      "currentStocksValue": 0.0
    });
  }

  // This stream notifies the Provider package of the updates in the database.
  Stream<List<Crypto>> get coins {
    return portfolioCollection
        .doc(uid)
        .collection('crypto')
        .snapshots()
        .map(_coinListFromSnapshot);
  }
}
