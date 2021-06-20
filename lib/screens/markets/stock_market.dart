// <---------- Dart Imports ---------->
import 'dart:async';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// <---------- Local Imports ---------->
import '../../models/stock.dart'; // Imports Stock Model.
import '../../shared/constants.dart'; // Imports UI Constants.
import '../../services/network/stock_network.dart'; // Imports Network Methods.

class StockMarketPage extends StatefulWidget {
  @override
  _StockMarketPageState createState() => _StockMarketPageState();
}

class _StockMarketPageState extends State<StockMarketPage> {
  List<Stock> stocks;
  List<Stock> stocksFiltered = [];

  @override
  void initState() {
    super.initState();
    if (this.mounted)
      setState(() {
        setData();
      });
  }

  void setData() async {
    stocks = await getStockData();
    if (this.mounted)
      setState(() {
        stocksFiltered = stocks;
      });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kDarkGrey,
      onRefresh: () {
        return Future.delayed(Duration(milliseconds: 400), () {
          setState(() {
            setData();
          });
        });
      },
      // <---------- Stock Details ---------->
      child: Container(
        decoration: BoxDecoration(color: kDarkGrey),
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
            color: kMediumGrey,
          ),
          itemCount: stocksFiltered.length + 1,
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
            stocksFiltered = stocks.where((stock) {
              return stock.name.toLowerCase().contains(text) ||
                  stock.ticker.toLowerCase().contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return ListTile(
      // <-------------- Show Stock Icon -------------->
      leading: CircleAvatar(
        // Choose Random Color for Stock Icon.
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        child: Text(
          stocksFiltered[index].name.toUpperCase()[0],
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      tileColor: kMediumGrey,
      // <----------- Show Stock Name ----------->
      title: Text(
        stocksFiltered[index].ticker.toUpperCase(),
        style: kListTextStyle,
      ),
      subtitle: Text(
        stocksFiltered[index].name,
        style: kListSubTextStyle,
      ),
      // <----------- Show Stock Price ----------->
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            // '₹ ${snapshot.data[index].currentPrice}',
            '${NumberFormat.simpleCurrency(
              locale: 'en_IN',
            ).format(stocksFiltered[index].currentPrice)}',
            style: kCurrentPriceTextStyle(stocksFiltered[index].percentage),
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
              // Change Color based on price movement.
              color: stocksFiltered[index].percentage >= 0
                  ? Colors.green
                  : Colors.red,
            ),
            // <--------- Show Percentage --------->
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Change icon based on price movement.
                  stocksFiltered[index].percentage >= 0 ? kUpArrow : kDownArrow,
                  Text(
                    '${stocksFiltered[index].percentage.abs()}%',
                    // '${percentage.abs().toStringAsFixed(2)}%',
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
