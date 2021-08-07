import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindrop/models/asset.dart';
import 'package:coindrop/screens/portfolio/widgets/portfolio_empty.dart';
import 'package:coindrop/screens/portfolio/widgets/stock_tile.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:coindrop/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StocksList extends StatefulWidget {
  final Function update;
  StocksList(this.update);

  @override
  _StocksListState createState() => _StocksListState();
}

class _StocksListState extends State<StocksList> {
  @override
  Widget build(BuildContext context) {
    // AppUser user = Provider.of<AppUser>(context);
    final stocks = Provider.of<List<Stocks>>(context) ?? [];
    return stocks.isNotEmpty
        ? Column(
            children: [
              Expanded(
                flex: 1,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("portfolios")
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var invested = snapshot.data["stocksInvested"];
                      var currentValue = snapshot.data["currentStocksValue"];
                      var profit = currentValue - invested;
                      var percentage = (profit / invested) * 100;
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 2,
                                right: 8,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.update();
                                    });
                                  },
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'PORTFOLIO VALUE',
                              style: TextStyle(
                                color: kAccentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 2).format(currentValue)} ',
                                  style: TextStyle(
                                    color: percentage < 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                Text(
                                  percentage > 0
                                      ? '+ ${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 2).format(profit)} (+${percentage.toStringAsFixed(2)}%)'
                                      : '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 2).format(profit)} (${percentage.toStringAsFixed(2)}%)',
                                  style: TextStyle(
                                    color: percentage < 0
                                        ? Colors.red
                                        : Colors.green,
                                    // fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'TOTAL INVESTED',
                              style: TextStyle(
                                color: kAccentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 2).format(invested)}',
                              style: TextStyle(
                                color: kAccentColor,
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  },
                ),
              ),
              Divider(
                height: 2,
                color: kAccentColor,
              ),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: stocks.length,
                  itemBuilder: (context, index) {
                    return StockTile(stock: stocks[index]);
                  },
                ),
              ),
            ],
          )
        : PortfolioEmpty('stocks');
  }
}
