// <------------ Create a Model to store Coin Data. ------------>
class Stock {
  String ticker;
  String name;
  num currentPrice;
  num percentage;
  var low;
  var high;
  var open;
  var closeyest;
  var volume;
  var high52;
  var low52;
  var marketcap;
  var pe;
  var eps;

  Stock(
      {this.ticker,
      this.name,
      this.currentPrice,
      this.open,
      this.high,
      this.low,
      this.percentage,
      this.closeyest,
      this.volume,
      this.high52,
      this.low52,
      this.marketcap,
      this.eps,
      this.pe});
}
