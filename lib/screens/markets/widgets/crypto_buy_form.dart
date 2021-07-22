import 'package:coindrop/models/coin.dart';
import 'package:coindrop/services/database/crypto_watchlist_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CryptoBuyForm extends StatefulWidget {
  final Coin coin;
  CryptoBuyForm(this.coin);
  @override
  _CryptoBuyFormState createState() => _CryptoBuyFormState();
}

class _CryptoBuyFormState extends State<CryptoBuyForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.coin.ticker.toUpperCase(),
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
                          'Your ${widget.coin.ticker.toUpperCase()} Buy Order has been fully executed.',
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
                    CoinWatchlistDatabaseService(
                            uid: FirebaseAuth.instance.currentUser.uid)
                        .addCoin(
                      ticker: widget.coin.ticker.toUpperCase(),
                      name: widget.coin.name,
                      currentPrice: widget.coin.currentPrice,
                      open: widget.coin.open,
                      high: widget.coin.high,
                      low: widget.coin.low,
                      percentage: widget.coin.percentage,
                      volume: widget.coin.volume,
                      buy: widget.coin.buy,
                      sell: widget.coin.sell,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(
                          milliseconds: 1500,
                        ),
                        backgroundColor: Colors.blue,
                        content: Text(
                          '${widget.coin.ticker.toUpperCase()} was added to your Watchlist.',
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
