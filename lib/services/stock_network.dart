import 'dart:convert';
import 'package:http/http.dart';
import '../models/stock.dart';

Future<List<Stock>> getStockData() async {
  List<Stock> stockList = [];
  var url = Uri.parse(
      'https://script.googleusercontent.com/macros/echo?user_content_key=L5vlcpkwp8_4lz-llBf9SI6qWPOwIqNb5ScKQV7Pks-gc7cFmJ7M2rY5M3R6ixqcix4ZQ2Md45VetBp6SBY3iXgHKx6CjXtCm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnBjWt9QOaNB3RcyTyZT5eo3ab5zBl_2BCn2345czLjbHoPnM6hPvjk9k6GNLsyfW1QNVHcmt-7IWocXVFttcMNf0GVpkSPAJJdz9Jw9Md8uu&lib=MBwU-wX6Djp4dKG66FJCLjijdirNHEf7t');
  // Send HTTP GET request to fetch coin data.
  Response response = await get(url);
  // Store data in the form of a dictionary (key:value pairs).
  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    // Add data of each coin into a list.
    for (int i = 0; i < data.length; i++) {
      Stock stock = Stock(
        ticker: data[i]['ticker'],
        name: data[i]['name'],
        currentPrice: data[i]['price'],
        high: data[i]['high'],
        low: data[i]['low'],
        open: data[i]['open'],
        percentage: data[i]['change'],
      );
      stockList.add(stock);
    }
    stockList.sort((a, b) => a.ticker.compareTo(b.ticker));
  } else {
    stockList = null;
  }
  return stockList;
}
