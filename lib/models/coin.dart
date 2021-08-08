class Coin {
  String ticker;
  String name;
  double low;
  double high;
  double open;
  double percentage;
  double currentPrice;
  double volume;
  double buy;
  double sell;

  Coin(
      {this.ticker,
      this.name,
      this.currentPrice,
      this.open,
      this.high,
      this.low,
      this.percentage,
      this.volume,
      this.buy,
      this.sell});
}
