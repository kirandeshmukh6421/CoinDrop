import 'package:cached_network_image/cached_network_image.dart';
import 'package:coindrop/models/coin.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:coindrop/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinTile extends StatefulWidget {
  final Coin coin;
  CoinTile({this.coin});

  @override
  _CoinTileState createState() => _CoinTileState();
}

class _CoinTileState extends State<CoinTile> {
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
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: CachedNetworkImage(
                  color: Colors.grey[400],
                  imageUrl:
                      'https://media.wazirx.com/media/${widget.coin.ticker.toLowerCase()}/84.png',
                  placeholder: (context, url) => Loading(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              title: Text(
                widget.coin.ticker.toUpperCase(),
                style: kListTextStyle,
              ),
              subtitle: Text(
                widget.coin.name,
                style: kListSubTextStyle,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.coin.currentPrice.toString().length - widget.coin.currentPrice.toString().indexOf(".")).format(widget.coin.currentPrice)}',
                    style: kCurrentPriceTextStyle(widget.coin.percentage),
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
                      color: widget.coin.percentage >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.coin.percentage >= 0 ? kUpArrow : kDownArrow,
                          Text(
                            '${widget.coin.percentage.abs().toStringAsFixed(2)}%',
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
                        '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.coin.high.toString().length - widget.coin.high.toString().indexOf(".")).format(widget.coin.high)}',
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
                        '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.coin.low.toString().length - widget.coin.low.toString().indexOf(".")).format(widget.coin.low)}',
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
                        '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.coin.open.toString().length - widget.coin.open.toString().indexOf(".")).format(widget.coin.open)}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      )
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
                        '${widget.coin.volume}',
                        style: kListTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BID/ASK',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.coin.buy.toString().length - widget.coin.buy.toString().indexOf(".")).format(widget.coin.buy)} / ${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: widget.coin.sell.toString().length - widget.coin.sell.toString().indexOf(".")).format(widget.coin.sell)}',
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
