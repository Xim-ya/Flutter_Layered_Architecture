/* 엔드포인트 메소드 자동화 ==> Retrofit  */
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:retrofitpractice/data/remote/network/api/article/response/article_response.dart';

// Generator
part 'article_api.g.dart';

// https://newsapi.org/v2/top-headlines?country=kr&apiKey=c4237fc3e9d74fcbb84d1b7a725efc41

@RestApi(baseUrl: "https://newsapi.org/v2/")
abstract class ArticleApi {
  factory ArticleApi(Dio dio, {String baseUrl}) = _ArticleApi;

  /* Path Mapping at Dio */
  @GET("top-headlines?apiKey=c4237fc3e9d74fcbb84d1b7a725efc41")
  Future<ArticleResponse> getArticle(
    @Query("country") String country,
  );
}
