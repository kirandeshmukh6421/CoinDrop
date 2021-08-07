import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/models/asset.dart';
import 'package:coindrop/screens/portfolio/widgets/crypto_list.dart';
import 'package:coindrop/services/database/crypto_portfolio_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptoPortfolio extends StatefulWidget {
  @override
  _CryptoPortfolioState createState() => _CryptoPortfolioState();
}

class _CryptoPortfolioState extends State<CryptoPortfolio> {
  @override
  void initState() {
    super.initState();
    update();
  }

  void update() async {
    await CryptoPortfolioDatabaseService(
            uid: FirebaseAuth.instance.currentUser.uid)
        .updatePortfolio();
    await CryptoPortfolioDatabaseService(
            uid: FirebaseAuth.instance.currentUser.uid)
        .updateTotalInvested();
    await Future.delayed(Duration(milliseconds: 1500));
    CryptoPortfolioDatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .updateCurrentValue();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamProvider<List<Crypto>>.value(
      initialData: null,
      value: CryptoPortfolioDatabaseService(uid: user.uid).coins,
      child: Container(
        child: Scaffold(
          backgroundColor: kMediumGrey,
          body: Container(
            child: CryptoList(update),
          ),
        ),
      ),
    );
  }
}
