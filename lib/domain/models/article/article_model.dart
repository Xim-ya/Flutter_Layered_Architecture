/*
* {
  "status": "ok",
  "totalResults": 34,
  "articles": [
    {
      "source": {
        "id": null,
        "name": "Nocutnews.co.kr"
      },
      "author": "조은정",
      "title": "\"아이들이 당신의 총보다 중요한가요\" 美 전역 번지는 시위 - 노컷뉴스",
      "description": "\"언제 우리 아이들이 당신의 총보다 더 중요해질까요?\" 텍사스 주지사 관저 앞 잔디밭이 한 어린 아이가 이같은 문구가 적힌 큰 종이 피켓을 덮고 누워있다. 미국 텍사스주 초등학교 총격 참사를 계기로 퍼포먼스를 ..",
      "url": "https://www.nocutnews.co.kr/news/5763160",
      "urlToImage": "https://file2.nocutnews.co.kr/newsroom/image/2022/05/27/202205271126350776_0.jpg",
      "publishedAt": "2022-05-27T02:27:00Z",
      "content": "\" ?\" . .26() .\r\n.\r\nNBC . , , , , , . .\r\n' '(SDA) \" . \" \" . \" .\r\n . \r\n .11 30 15 4 . 'U' .\r\n2 \" . \" \" \" AP .\r\n' '(Everytown for Gun Safety) 80 .\r\n19 21 , ."
    },
    {
      "source": {
        "id": null,
        "name": "Kbench.com"
      },
      "author": null,
      "title": "콜 오브 듀티 워존 및
*
* */

import 'package:retrofitpractice/data/remote/network/api/article/response/article_response.dart';

class ArticleModel {
  final String? status;
  final int? totalResults;
  final List<ArticleCoreModel> articles;

  const ArticleModel({this.status, this.totalResults, required this.articles});

  factory ArticleModel.fromResponse(ArticleResponse response) {
    List<ArticleCoreModel> result = (response.articles)
        .map((e) => ArticleCoreModel.fromResponse(e))
        .toList();
    return ArticleModel(
      status: response.status,
      totalResults: response.totalResults,
      articles: result,
    );
  }
}

/* 모델에서 필요한 데이터 포맷으로 변환 */
class ArticleCoreModel {
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  // final String? content; // <-- Remove This Member Variable

  const ArticleCoreModel({
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
  });

  factory ArticleCoreModel.fromResponse(ArticleCoreResponse response) =>
      ArticleCoreModel(
        author: response.author,
        title: response.title,
        description: response.description,
        url: response.url,
        urlToImage: response.imageUrl,
        publishedAt: response.date,
      );
}
