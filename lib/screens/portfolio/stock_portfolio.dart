import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/models/asset.dart';
import 'package:coindrop/screens/portfolio/widgets/stocks_list.dart';
import 'package:coindrop/services/database/stock_portfolio_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockPortfolio extends StatefulWidget {
  @override
  _StockPortfolioState createState() => _StockPortfolioState();
}

class _StockPortfolioState extends State<StockPortfolio> {
  void initState() {
    super.initState();
    update();
  }

  void update() async {
    await StockPortfolioDatabaseService(
            uid: FirebaseAuth.instance.currentUser.uid)
        .updatePortfolio();
    await StockPortfolioDatabaseService(
            uid: FirebaseAuth.instance.currentUser.uid)
        .updateTotalInvested();
    await Future.delayed(Duration(milliseconds: 1500));
    StockPortfolioDatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .updateCurrentValue();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamProvider<List<Stocks>>.value(
      initialData: null,
      value: StockPortfolioDatabaseService(uid: user.uid).stocks,
      child: Container(
        child: Scaffold(
          backgroundColor: kMediumGrey,
          body: Container(
            child: StocksList(update),
          ),
        ),
      ),
    );
  }
}
