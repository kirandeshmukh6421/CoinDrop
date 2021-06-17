// <------------ Create a Model to store Coin Data. ------------>
class Coin {
  var ticker;
  var name;
  var low;
  var high;
  var open;
  var percentage;
  var currentPrice;

  Coin({
    this.ticker,
    this.name,
    this.currentPrice,
    this.open,
    this.high,
    this.low,
    this.percentage,
  });
}
