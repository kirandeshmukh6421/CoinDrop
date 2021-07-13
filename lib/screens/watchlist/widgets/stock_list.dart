import 'package:coindrop/models/stock.dart';
import 'package:coindrop/screens/watchlist/widgets/stock_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  @override
  Widget build(BuildContext context) {
    final stocks = Provider.of<List<Stock>>(context) ?? [];
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        return StockTile(stock: stocks[index]);
      },
    );
  }
}
