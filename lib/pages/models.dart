class NewsQueryModel {
  late String newsHead;
  late String newsDes;
  late String newsImg;
  late String newsUrl;
  NewsQueryModel(
      {this.newsDes = 'News HeadLine',
      this.newsHead = 'News Description',
      this.newsImg = 'News Image',
      this.newsUrl = 'News URL'});
  factory NewsQueryModel.fromMap(Map news) {
    return NewsQueryModel(
      newsHead: news['title'],
      newsDes: news['description'],
      newsImg: news['urlToImage'],
      newsUrl: news['url'],
    );
  }
}
