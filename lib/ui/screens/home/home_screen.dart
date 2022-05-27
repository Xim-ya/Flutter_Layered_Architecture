import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/http.dart';

import '../../../data/remote/network/api/article/article_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ArticleApi client;

  @override
  void initState() {
    super.initState();
    Dio dio = Dio();
    client = ArticleApi(dio);

    Future.microtask(() async {
      final resp = await client.getArticle();
      print(resp.articles![1].title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Get Rid Of It"),
        ],
      ),
    );
  }
}
