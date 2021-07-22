import 'package:coindrop/models/stock.dart';
import 'package:coindrop/services/database/stock_watchlist_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StockBuyForm extends StatefulWidget {
  final Stock stock;
  StockBuyForm(this.stock);

  @override
  _StockBuyFormState createState() => _StockBuyFormState();
}

class _StockBuyFormState extends State<StockBuyForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(
                          milliseconds: 1500,
                        ),
                        backgroundColor: Colors.green,
                        content: Text(
                          'Your ${widget.stock.ticker.toUpperCase()} Buy Order has been fully executed.',
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
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'BUY',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    StockWatchlistDatabaseService(
                            uid: FirebaseAuth.instance.currentUser.uid)
                        .addStock(
                      ticker: widget.stock.ticker.toUpperCase(),
                      name: widget.stock.name,
                      currentPrice: widget.stock.currentPrice,
                      open: widget.stock.open,
                      high: widget.stock.high,
                      low: widget.stock.low,
                      percentage: widget.stock.percentage,
                      volume: widget.stock.volume,
                      closeyest: widget.stock.closeyest,
                      marketcap: widget.stock.marketcap,
                      eps: widget.stock.eps,
                      pe: widget.stock.pe,
                      high52: widget.stock.high52,
                      low52: widget.stock.low52,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text(
                        '${widget.stock.ticker.toUpperCase()} was added to your Watchlist.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ));
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
                        'FAVORITE',
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
      ),
    );
  }
}
