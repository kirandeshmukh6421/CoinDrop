import 'package:http/http.dart';
import 'dart:convert';
import '../models/coin.dart';

Future<List<Coin>> getCoinData() async {
  var ticker, name, currentPrice, high, low, open, percentage;
  List<Coin> coinList = [];
  var coinUrl = Uri.parse('https://api.wazirx.com/api/v2/tickers');
  // Send HTTP GET request to fetch coin data.
  Response response = await get(coinUrl);
  // Store data in the form of a dictionary (key:value pairs).
  if (response.statusCode == 200) {
    Map data = jsonDecode(response.body);
    // Add data of each coin into a list.
    data.forEach((key, value) async {
      if (data[key]['quote_unit'] == 'inr') {
        ticker = data[key]['base_unit'];
        name = data[key]['name'];
        currentPrice = double.parse(data[key]['last']);
        high = double.parse(data[key]['high']);
        low = double.parse(data[key]['low']);
        open = data[key]['open'].runtimeType == String
            ? double.parse(data[key]['open'])
            : data[key]['open'];
        percentage = ((double.parse(data[key]['last']) - open) / open) * 100;
        Coin coin = Coin(
          ticker: ticker,
          name: name,
          currentPrice: currentPrice,
          high: high,
          low: low,
          open: open,
          percentage: percentage,
        );
        coinList.add(coin);
      }
    });
    coinList.sort((a, b) => a.name.compareTo(b.name));
  } else {
    coinList = null;
  }
  return coinList;
}

