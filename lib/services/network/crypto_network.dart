import 'package:http/http.dart';
import 'dart:convert';
import '../../models/coin.dart';

class CryptoNetwork {
  Future<List<Coin>> getCoins() async {
    var ticker,
        name,
        currentPrice,
        high,
        low,
        open,
        percentage,
        buy,
        sell,
        volume;
    List<Coin> coinList = [];
    List tempCoinList = [];
    var coinUrl = Uri.parse('https://api.wazirx.com/api/v2/market-status');
    // Send HTTP GET request to fetch coin data.
    Response response = await get(coinUrl);
    // Store data in the form of a dictionary (key:value pairs).
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List markets = data["markets"];
      List assets = data["assets"];

      // Add data of each coin into a list.
      for (var item in markets) {
        if (item["quoteMarket"] == "inr" &&
            item["type"] == "SPOT" &&
            item["status"] == "active") {
          tempCoinList.add(item);
        }
      }
      for (var item in assets) {
        for (var coin in tempCoinList) {
          if (coin["baseMarket"] == item["type"]) {
            ticker = coin['baseMarket'];
            name = item['name'];
            currentPrice = double.parse(coin['last']);
            high = double.parse(coin['high'].toString());
            low = double.parse(coin['low'].toString());
            open = double.parse(coin['open'].toString());
            percentage =
                ((double.parse(coin['last'].toString()) - open) / open) * 100;
            buy = double.parse(coin['buy'].toString());
            sell = double.parse(coin['sell'].toString());
            volume = double.parse(coin['volume'].toString());

            Coin coinItem = Coin(
                ticker: ticker,
                name: name,
                currentPrice: currentPrice,
                high: high,
                low: low,
                open: open,
                percentage: percentage,
                buy: buy,
                sell: sell,
                volume: volume);
            coinList.add(coinItem);
          }
        }
      }
      coinList.sort((a, b) => a.ticker.compareTo(b.ticker));
    } else {
      coinList = null;
    }
    return coinList;
  }
}
