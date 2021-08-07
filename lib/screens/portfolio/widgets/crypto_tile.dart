import 'package:cached_network_image/cached_network_image.dart';
import 'package:coindrop/models/asset.dart';
import 'package:coindrop/screens/portfolio/widgets/crypto_sell_form.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:coindrop/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CryptoTile extends StatefulWidget {
  final Crypto coin;
  CryptoTile({this.coin});

  @override
  _CryptoTileState createState() => _CryptoTileState();
}

class _CryptoTileState extends State<CryptoTile> {
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
                          child: CryptoSellForm(widget.coin),
                        ),
                      );
                    });
              },
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
                    '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 3).format(widget.coin.profit.abs())}',
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
                        'INVESTED',
                        style: kListSubTextStyle.copyWith(fontSize: 13),
                      ),
                      Text(
                        '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 2).format(widget.coin.invested)}',
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
                        '${NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 2).format(widget.coin.currentValue)}',
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
                        widget.coin.quantity.toString(),
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
