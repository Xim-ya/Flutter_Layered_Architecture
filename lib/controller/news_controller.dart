// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:retrofitpractice/retrofit/rest_client.dart';
//
// enum LoadingStatus { done, empty }
//
// class NewsController extends GetxController {
//   final client = RestClient(Dio()); // Retrofit
//   LoadingStatus loadingStatus = LoadingStatus.empty; // 응답 여부
//   List<int> idList = []; // Top Rated 뉴스 아이디 리스트
//   List<News> newsList = [];
//
//   void fetchNewsApi() async {
//     idList = await client.getIdList(); // Retrofit
//     final what = await client.getNewsDetail(31515517);
//     print(what);
//
//     update();
//   }
//
//   @override
//   void onInit() async {
//     super.onInit();
//     fetchNewsApi();
//   }
// }
