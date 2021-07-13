import 'dart:convert';
import 'package:http/http.dart';
import '../../models/stock.dart';

class StockNetwork {
  Future<List<Stock>> getStocks() async {
    List<Stock> stockList = [];
    var url = Uri.parse(
        'https://script.googleusercontent.com/macros/echo?user_content_key=jlAJqgmRrk_0p7ODOXHeHgseSdYjC6fSUTsriqcj5GNxcPXxCjyknRS-D3wfhCI3RNGcdkB31r_Ck9qGyK5HdFAUR19YEf28m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnJYKFJ7HW08Z9F7G3-XP7bFrRvJhxX-PFNDTzAbojsZLQHLeTE0sbdOTQtse5ov4jx9YTvSkEsla6GMq52XJUZNRqM7RMRhLCg&lib=MBwU-wX6Djp4dKG66FJCLjijdirNHEf7t');
    // Send HTTP GET request to fetch stock data.
    Response response = await get(url);
    // Store data in the form of a dictionary (key:value pairs).
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      // Add data of each stock into a list.
      data.forEach((key, value) {
        if (data[key]['price'].runtimeType != String &&
            data[key]['change'].runtimeType != String &&
            data[key]['high'].runtimeType != String &&
            data[key]['low'].runtimeType != String &&
            data[key]['open'].runtimeType != String &&
            data[key]['cloesyest'].runtimeType != String &&
            data[key]['volume'].runtimeType != String &&
            data[key]['pe'].runtimeType != String &&
            data[key]['eps'].runtimeType != String &&
            data[key]['high52'].runtimeType != String &&
            data[key]['low52'].runtimeType != String &&
            data[key]['marketcap'].runtimeType != String) {
          Stock stock = Stock(
              ticker: data[key]['ticker'].toString(),
              name: data[key]['name'].toString(),
              currentPrice: double.parse(data[key]['price'].toString()),
              percentage: double.parse(data[key]['change'].toString()),
              high: data[key]['high'],
              low: data[key]['low'],
              open: data[key]['open'],
              closeyest: data[key]['closeyest'],
              eps: data[key]['eps'],
              pe: data[key]['pe'],
              high52: data[key]['high52'],
              low52: data[key]['low52'],
              marketcap: data[key]['marketcap'],
              volume: data[key]['volume']);
          stockList.add(stock);
        }
      });
      stockList.sort((a, b) => a.ticker.compareTo(b.ticker));
      print(stockList.length);
    } else {
      stockList = null;
    }
    return stockList;
  }
}
// https://script.googleusercontent.com/macros/echo?user_content_key=jlAJqgmRrk_0p7ODOXHeHgseSdYjC6fSUTsriqcj5GNxcPXxCjyknRS-D3wfhCI3RNGcdkB31r_Ck9qGyK5HdFAUR19YEf28m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnJYKFJ7HW08Z9F7G3-XP7bFrRvJhxX-PFNDTzAbojsZLQHLeTE0sbdOTQtse5ov4jx9YTvSkEsla6GMq52XJUZNRqM7RMRhLCg&lib=MBwU-wX6Djp4dKG66FJCLjijdirNHEf7t

// https://script.googleusercontent.com/macros/echo?user_content_key=FK4fSy7d3EnGSvJgTWYkJbm2m8wPsxZtyg9-6vsGOrOekROptW5pzrZQ3Hi-fqXYAg4fCmTNWqxqZolItlFT5dq1txtlBKk4m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnK4sh_8-JujIb3Zab1Rb16WRojVtQ2bxscevhkGZ4rbpWFUjz8x0A-I9umOt39yK__rd_TEPukLLhgAHaT6CNM6CZ6KYumhkDdz9Jw9Md8uu&lib=MBwU-wX6Djp4dKG66FJCLjijdirNHEf7t
