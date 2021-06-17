// <------------ Create a Model to store Coin Data. ------------>
class Stock {
  var ticker;
  var name;
  var low;
  var high;
  var open;
  var percentage;
  var currentPrice;

  Stock({
    this.ticker,
    this.name,
    this.currentPrice,
    this.open,
    this.high,
    this.low,
    this.percentage,
  });
}
