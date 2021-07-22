import 'package:coindrop/models/coin.dart';
import 'package:coindrop/services/database/crypto_watchlist_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CryptoRemoveForm extends StatefulWidget {
  final Coin coin;
  CryptoRemoveForm(this.coin);
  @override
  _CryptoRemoveFormState createState() => _CryptoRemoveFormState();
}

class _CryptoRemoveFormState extends State<CryptoRemoveForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  CoinWatchlistDatabaseService(
                          uid: FirebaseAuth.instance.currentUser.uid)
                      .removeCoin(
                    widget.coin.ticker.toUpperCase(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(
                        milliseconds: 1500,
                      ),
                      backgroundColor: Colors.blue,
                      content: Text(
                        '${widget.coin.ticker.toUpperCase()} was removed from your Watchlist.',
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
