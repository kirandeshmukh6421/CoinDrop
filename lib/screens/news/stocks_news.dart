import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_tracker/shared/loading.dart';
import 'package:url_launcher/link.dart';
import '../../services/news_network.dart';
import '../../shared/constants.dart';
import '../../models/news.dart';

class StocksNews extends StatefulWidget {
  @override
  _StocksNewsState createState() => _StocksNewsState();
}

class _StocksNewsState extends State<StocksNews> {
  List<News> _news;
  @override
  void initState() {
    super.initState();

    setData();
  }

  void setData() async {
    List newsData = await getNews("Bombay Stock Exchange");
    if (this.mounted)
      setState(() {
        _news = newsData;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kDarkGrey),
      child: _news == null
          ? Loading()
          : ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                color: kMediumGrey,
              ),
              itemCount: _news.length,
              itemBuilder: (context, index) {
                return _listItem(index);
              },
            ),
    );
  }

  _listItem(index) {
    return Link(
      uri: Uri.parse(_news[index].link),
      target: LinkTarget.blank,
      builder: (ctx, openLink) {
        return ListTile(
          onTap: openLink,
          tileColor: kMediumGrey,
          leading: CircleAvatar(
              radius: 30,
              backgroundColor: kMediumGrey,
              child: CachedNetworkImage(
                imageUrl: _news[index].image ??
                    'https://via.placeholder.com/150/000000/FFFFFF/?text=Portfolio+Tracker',
                placeholder: (context, url) => Loading(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )),
          title: Text(
            _news[index].headline,
            style: kNewsTextStyle,
          ),
          subtitle: Text(
            _news[index].source,
            style: kListSubTextStyle,
          ),
          contentPadding: EdgeInsets.only(
            bottom: 4.0,
            top: 4.0,
            left: 6.0,
            right: 8.0,
          ),
        );
      },
    );
  }
}
