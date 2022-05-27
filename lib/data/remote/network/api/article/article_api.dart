/* 엔드포인트 메소드 자동화 ==> Retrofit  */
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:retrofitpractice/data/remote/network/api/article/response/article_response.dart';

// Generator
part 'article_api.g.dart';

// https://newsapi.org/v2/top-headlines?country=kr&apiKey=c4237fc3e9d74fcbb84d1b7a725efc41

// '@' <-- Annotation
@RestApi(baseUrl: "https://newsapi.org/v2/")
abstract class ArticleApi {
  factory ArticleApi(Dio dio, {String baseUrl}) = _ArticleApi;

  /* Path Mapping at Dio */
  @GET("top-headlines?country=kr&apiKey=c4237fc3e9d74fcbb84d1b7a725efc41")
  Future<NewsResponse> getArticle();
}

// @JsonSerializable()
// class News {
//   String? status;
//   int? totalResults;
//   List<Article>? articles;
//
//   News({this.status, this.totalResults, this.articles});
//
//   factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
//   // To json -> 객체에서 to json
//   Map<String, dynamic> toJson() => _$NewsToJson(this);
// }

// // Api에서 받아올 Json 객체, 모든 요소를 받음.
// @JsonSerializable()
// class Article {
//   String? author;
//   String? title;
//   String? description;
//   String? url;
//   String? urlToImage;
//   String? publishedAt;
//   String? content;
//
//   Article(this.author, this.title, this.description, this.url, this.urlToImage,
//       this.publishedAt, this.content); // 멤버 변수 매핑
//
//   // Json으로부터 객체를 변환하는 경우
//   factory Article.fromJson(Map<String, dynamic> json) =>
//       _$ArticleFromJson(json);
//   // To json -> 객체에서 to json
//   Map<String, dynamic> toJson() => _$ArticleToJson(this);
// }
