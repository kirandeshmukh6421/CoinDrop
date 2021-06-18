// <---------- Dart Imports ---------->
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:coindrop/shared/loading.dart';

// <---------- Local Imports ---------->
import '../../models/coin.dart'; // Imports Coin Model.
import '../../shared/constants.dart'; // Imports UI Constants.
import '../../services/crypto_network.dart'; // Imports Network Methods.

class CryptoMarketPage extends StatefulWidget {
  @override
  _CryptoMarketPageState createState() => _CryptoMarketPageState();
}

class _CryptoMarketPageState extends State<CryptoMarketPage> {
  List<Coin> coins;
  List<Coin> coinsFiltered = [];

  @override
  void initState() {
    super.initState();
    if (this.mounted)
      setState(() {
        setData();
      });
  }

  void setData() async {
    coins = await getCoinData();
    if (this.mounted)
      setState(() {
        coinsFiltered = coins;
      });
  }

  @override
  Widget build(BuildContext context) {
    // <---------- Refresh Functionality ---------->
    return RefreshIndicator(
      color: kDarkGrey,
      onRefresh: () {
        return Future.delayed(Duration(milliseconds: 400), () {
          setState(() {
            setData();
          });
        });
      },
      // <---------- Coin Details ---------->
      child: Container(
        decoration: BoxDecoration(color: kDarkGrey),
        child: ListView.separated(
          key: new PageStorageKey('myListView'),
          physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
            color: kMediumGrey,
          ),
          itemCount: coinsFiltered.length + 1,
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index - 1);
          },
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            )),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            coinsFiltered = coins.where((coin) {
              return coin.name.toLowerCase().contains(text) ||
                  coin.ticker.toLowerCase().contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return ListTile(
      onTap: () {},
      tileColor: kMediumGrey,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: CachedNetworkImage(
          color: Colors.grey[400],
          imageUrl:
              'https://media.wazirx.com/media/${coinsFiltered[index].ticker.toLowerCase()}/84.png',
          placeholder: (context, url) => Loading(),
          errorWidget: (context, url, error) => Icon(
            Icons.error,
            color: Colors.grey[400],
          ),
        ),
      ),
      title: Text(
        coinsFiltered[index].ticker.toUpperCase(),
        style: kListTextStyle,
      ),
      subtitle: Text(
        coinsFiltered[index].name,
        style: kListSubTextStyle,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: coinsFiltered[index].currentPrice.toString().length - coinsFiltered[index].currentPrice.toString().indexOf(".")).format(coinsFiltered[index].currentPrice)}',
            style: kCurrentPriceTextStyle(coinsFiltered[index].percentage),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.all(4),
            width: MediaQuery.of(context).size.width / 4.8,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: coinsFiltered[index].percentage >= 0
                  ? Colors.green
                  : Colors.red,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  coinsFiltered[index].percentage >= 0 ? kUpArrow : kDownArrow,
                  Text(
                    '${coinsFiltered[index].percentage.abs().toStringAsFixed(2)}%',
                    style: kPercentageTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.only(
        bottom: 4.0,
        top: 4.0,
        left: 6.0,
        right: 8.0,
      ),
    );
  }
}
