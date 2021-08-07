import 'package:coindrop/models/asset.dart';
import 'package:coindrop/screens/portfolio/widgets/stock_sell_form.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class StockTile extends StatefulWidget {
  final Stocks stock;
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
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: StockSellForm(widget.stock),
                        ),
                      );
                    });
              },
              leading: CircleAvatar(
                backgroundColor:
                    Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(1.0),
                child: Text(widget.stock.ticker[0]),
              ),
              title: Text(
                widget.stock.ticker.toUpperCase(),
                style: kListTextStyle.copyWith(
                  fontSize: 17,
                ),
              ),
              subtitle: Text(
                widget.stock.name,
                style: kListSubTextStyle,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 3).format(widget.stock.profit.abs())}',
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
                        'INVESTED',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 2).format(widget.stock.invested)}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CURRENT VALUE',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 2).format(widget.stock.currentValue)}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QUANTITY',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        widget.stock.quantity.toString(),
                        style: kListTextStyle.copyWith(fontSize: 14),
                      )
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
