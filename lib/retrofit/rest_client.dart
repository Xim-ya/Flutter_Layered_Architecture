// /* 엔드포인트 메소드 자동화 ==> Retrofit  */
// import 'package:json_annotation/json_annotation.dart';
// import 'package:retrofit/retrofit.dart';
// import 'package:dio/dio.dart';
//
// // Generator
// part 'rest_client.g.dart';
//
// // '@' <-- Annotation
// @RestApi(baseUrl: "https://hacker-news.firebaseio.com/v0/")
// abstract class RestClient {
//   factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
//
//   /* Path Mapping at Dio */
//   @GET("topstories.json")
//   Future<List<int>> getIdList();
//
//   @GET("item/{id}.json")
//   Future<List<News>> getNewsDetail(
//       @Path() int id); // Path의 인자를 받기 위해 인자 Path 설정
// }
//
// @JsonSerializable()
// class News {
//   int? id;
//   String? type;
//   String? url;
//   String? title;
//
//   // 멤버 변수 매핑
//   News({this.id, this.type, this.url, this.title});
//
//   // 객체를 변환하는 경우
//   factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
//   // To json -> 객체에서 to json
//   Map<String, dynamic> toJson() => _$NewsToJson(this);
// }
