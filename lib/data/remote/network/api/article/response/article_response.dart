import 'package:json_annotation/json_annotation.dart';
import 'package:retrofitpractice/data/remote/network/dio/int_converter.dart';
import 'package:retrofitpractice/data/remote/network/dio/string_converter.dart';

part 'article_response.g.dart';

/* `Article` Response Json 객체 */
/*  원본 JSON :
*  {
*     "status" : "ok",
*     "totalResults" : 34,
*     "articles" : [
*           source": {
            "id": null,
            "name": "Nocutnews.co.kr"
          },
            "author": "조은정",
             "title": "\"아이들이 당신의 총보다 중요한가요\" 美 전역 번지는 시위 - 노컷뉴스",
             "description": "\"언제 우리 아이들이 당신의 총보다 더 중요해질까요?\" 텍사스 주지사 관저 앞 잔디밭이 한 어린 아이가 이같은 문구가 적힌 큰 종이 피켓을 덮고 누워있다. 미국 텍사스주 초등학교 총격 참사를 계기로 퍼포먼스를 ..",
      *
*   ],
*  }
* */

@JsonSerializable(createToJson: false)
class ArticleResponse {
  @JsonKey(name: 'status')
  @StringConverter()
  final String? status;

  @JsonKey(name: 'totalResults')
  @IntConverter()
  final int? totalResults;

  @JsonKey(name: 'articles')
  final List<ArticleCoreResponse> articles;

  const ArticleResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);
}

/*
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
* */

@JsonSerializable(createToJson: false)
class ArticleCoreResponse {
  @JsonKey(name: 'author')
  @StringConverter()
  final String? author;

  @JsonKey(name: 'title')
  @StringConverter()
  final String? title;

  @JsonKey(name: 'description')
  @StringConverter()
  final String? description;

  @JsonKey(name: 'url')
  @StringConverter()
  final String? url;

  @JsonKey(name: "urlToImage")
  @StringConverter()
  final String? imageUrl; // keyName 변경

  @JsonKey(name: "publishedAt")
  @StringConverter()
  final String? date; // keyName 변경

  @JsonKey(name: "content")
  @StringConverter()
  final String? content;

  const ArticleCoreResponse(
      {required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.imageUrl,
      required this.date,
      required this.content});

  factory ArticleCoreResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleCoreResponseFromJson(json);
}
