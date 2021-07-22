import 'package:coindrop/models/stock.dart';
import 'package:coindrop/services/database/stock_watchlist_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StockRemoveForm extends StatefulWidget {
  final Stock stock;
  StockRemoveForm(this.stock);
  @override
  _StockRemoveFormState createState() => _StockRemoveFormState();
}

class _StockRemoveFormState extends State<StockRemoveForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          widget.stock.ticker.toUpperCase(),
          style: kListTextStyle,
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  StockWatchlistDatabaseService(
                          uid: FirebaseAuth.instance.currentUser.uid)
                      .removeStock(
                    widget.stock.ticker.toUpperCase(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(
                        milliseconds: 1500,
                      ),
                      backgroundColor: Colors.blue,
                      content: Text(
                        '${widget.stock.ticker.toUpperCase()} was removed from your Watchlist.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'REMOVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
