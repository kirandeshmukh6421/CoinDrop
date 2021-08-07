import 'package:coindrop/models/asset.dart';
import 'package:coindrop/services/database/crypto_portfolio_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CryptoSellForm extends StatefulWidget {
  final Crypto coin;
  CryptoSellForm(this.coin);

  @override
  _CryptoSellFormState createState() => _CryptoSellFormState();
}

class _CryptoSellFormState extends State<CryptoSellForm> {
  void initState() {
    _priceController = new TextEditingController();
    _quantityController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController?.dispose();
    _quantityController?.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  // Form Values
  double _price;
  double _quantity;
  TextEditingController _priceController;
  TextEditingController _quantityController;

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
                  controller: _priceController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                  textAlign: TextAlign.center,
                  // initialValue: "${widget.coin.currentPrice}",
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
                    _priceController.text =
                        "${widget.coin.currentValue / widget.coin.quantity}";
                    _price = widget.coin.currentValue / widget.coin.quantity;
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
                  controller: _quantityController,
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
                        if (double.parse(val) > widget.coin.quantity) {
                          return 'You do not own enough ${widget.coin.ticker}';
                        }
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _quantityController.text = "${widget.coin.quantity}";
                    _quantity = widget.coin.quantity;
                  });
                },
                child: Text(
                  'ALL',
                  style: kLabelStyle.copyWith(fontSize: 16),
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
                      await CryptoPortfolioDatabaseService(
                              uid: FirebaseAuth.instance.currentUser.uid)
                          .sellCoin(
                        ticker: widget.coin.ticker.toUpperCase(),
                        price: _price,
                        quantity: _quantity,
                        invested: (_price * _quantity),
                      );
                      await CryptoPortfolioDatabaseService(
                              uid: FirebaseAuth.instance.currentUser.uid)
                          .updatePortfolio();
                      CryptoPortfolioDatabaseService(
                              uid: FirebaseAuth.instance.currentUser.uid)
                          .updateTotalInvested();
                      CryptoPortfolioDatabaseService(
                              uid: FirebaseAuth.instance.currentUser.uid)
                          .updateCurrentValue();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(
                            milliseconds: 1500,
                          ),
                          backgroundColor: Colors.green,
                          content: Text(
                            'Your ${widget.coin.ticker.toUpperCase()} Sell Order has been fully executed.',
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'SELL',
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
