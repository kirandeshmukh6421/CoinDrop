import 'package:coindrop/models/stock.dart';
import 'package:coindrop/screens/watchlist/widgets/stock_remove_form.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

class StockTile extends StatefulWidget {
  final Stock stock;
  StockTile({this.stock});
  @override
  _StockTileState createState() => _StockTileState();
}

class _StockTileState extends State<StockTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Color(0xFF2f2f2f),
        elevation: 0.0,
        margin: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        color: kMediumGrey,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 60.0),
                        child: StockRemoveForm(widget.stock),
                      );
                    });
              },
              leading: CircleAvatar(
                // Choose Random Color for Stock Icon.
                backgroundColor:
                    Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(1.0),
                child: Text(
                  widget.stock.name.toUpperCase()[0],
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              title: Text(
                widget.stock.ticker.toUpperCase(),
                style: kListTextStyle.copyWith(fontSize: 17),
              ),
              subtitle: Text(
                widget.stock.name,
                style: kListSubTextStyle,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.stock.currentPrice.toString().length - widget.stock.currentPrice.toString().indexOf(".")).format(double.parse(widget.stock.currentPrice.toString()))}',
                    style: kCurrentPriceTextStyle(widget.stock.percentage),
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
                      color: widget.stock.percentage >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.stock.percentage >= 0 ? kUpArrow : kDownArrow,
                          Text(
                            '${widget.stock.percentage.abs().toStringAsFixed(2)}%',
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
            ),
            Divider(
              height: 2.0,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HIGH',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        widget.stock.high.runtimeType == String
                            ? '${widget.stock.high}'
                            : '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.stock.high.toString().length - widget.stock.high.toString().indexOf(".")).format(double.parse(widget.stock.high.toString()))}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LOW',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        widget.stock.low.runtimeType == String
                            ? '${widget.stock.low}'
                            : '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.stock.low.toString().length - widget.stock.low.toString().indexOf(".")).format(double.parse(widget.stock.low.toString()))}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OPEN',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        widget.stock.open.runtimeType == String
                            ? '${widget.stock.open}'
                            : '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.stock.open.toString().length - widget.stock.open.toString().indexOf(".")).format(double.parse(widget.stock.open.toString()))}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CLOSE',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        widget.stock.closeyest.runtimeType == String
                            ? '${widget.stock.closeyest}'
                            : '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.stock.closeyest.toString().length - widget.stock.closeyest.toString().indexOf(".")).format(double.parse(widget.stock.closeyest.toString()))}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '52W HIGH',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        widget.stock.high52.runtimeType == String
                            ? '${widget.stock.high52}'
                            : '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.stock.high52.toString().length - widget.stock.high52.toString().indexOf(".")).format(double.parse(widget.stock.high52.toString()))}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '52W LOW',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        widget.stock.low52.runtimeType == String
                            ? '${widget.stock.low52}'
                            : '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.stock.low52.toString().length - widget.stock.low52.toString().indexOf(".")).format(double.parse(widget.stock.low52.toString()))}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'P/E',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        '${widget.stock.pe}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EPS',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        '${widget.stock.eps}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'VOLUME',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        '${widget.stock.volume}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MARKET CAP',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        widget.stock.marketcap.runtimeType == String
                            ? '${widget.stock.marketcap}'
                            : '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.stock.marketcap.toString().length - widget.stock.marketcap.toString().indexOf(".")).format(double.parse(widget.stock.marketcap.toString()))}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
