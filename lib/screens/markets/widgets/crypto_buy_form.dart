import 'package:coindrop/models/coin.dart';
import 'package:coindrop/services/database/crypto_portfolio_database.dart';
import 'package:coindrop/services/database/crypto_watchlist_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CryptoBuyForm extends StatefulWidget {
  final Coin coin;
  CryptoBuyForm(this.coin);
  @override
  _CryptoBuyFormState createState() => _CryptoBuyFormState();
}

class _CryptoBuyFormState extends State<CryptoBuyForm> {
  void initState() {
    _c = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  // Form Values
  double _price;
  double _quantity;
  TextEditingController _c;

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
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Price:',
                style: kLabelStyle.copyWith(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: 35,
              ),
              Flexible(
                child: TextFormField(
                  controller: _c,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  validator: (val) {
                    if (val != '') {
                      try {
                        double.parse(val);
                        return null;
                      } catch (e) {
                        return 'Enter a valid number';
                      }
                    } else {
                      return 'Enter a valid number';
                    }
                  },
                  onChanged: (val) {
                    setState(() => _price = double.parse(val.trim()));
                  },
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _c.text = "${widget.coin.currentPrice}";
                    _price = widget.coin.currentPrice;
                  });
                },
                child: Text(
                  'CMP',
                  style: kLabelStyle.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                'Amount:',
                style: kLabelStyle.copyWith(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  // initialValue: "10",
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  validator: (val) {
                    if (val != '') {
                      try {
                        double.parse(val);
                        return null;
                      } catch (e) {
                        return 'Enter a valid number';
                      }
                    } else {
                      return 'Enter a valid number';
                    }
                  },
                  onChanged: (val) {
                    setState(() => _quantity = double.parse(val.trim()));
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if (await CryptoPortfolioDatabaseService(
                                  uid: FirebaseAuth.instance.currentUser.uid)
                              .checkIfDocExists(
                                  widget.coin.ticker.toUpperCase()) ==
                          false) {
                        await CryptoPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .buyCoin(
                          name: widget.coin.name,
                          ticker: widget.coin.ticker.toUpperCase(),
                          currentValue: (_quantity * _price),
                          invested: (_quantity * _price),
                          percentage: 0,
                          profit: 0,
                          quantity: _quantity,
                        );
                        CryptoPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updateTotalInvested();
                        CryptoPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updateCurrentValue();
                      } else {
                        CryptoPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updatePortfolio();
                        await CryptoPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .partialBuy(
                          ticker: widget.coin.ticker.toUpperCase(),
                          price: _price,
                          quantity: _quantity,
                          invested: (_price * _quantity),
                        );
                        CryptoPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updateTotalInvested();
                        CryptoPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updateCurrentValue();
                      }

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
                    }
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
