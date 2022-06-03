import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:retrofitpractice/ui/screens/home/home_view_model.dart';

import '../../../data/local/persistence/dao/article/article_dao.dart';
import '../../../data/local/persistence/dao/article/document/article_document.dart';
import '../../../data/local/persistence/hive/app_data_base.dart';
import '../../../data/local/source/article_local_data_source.dart';
import '../../../data/local/source/article_local_data_source_impl.dart';
import '../../../data/remote/network/api/article/article_api.dart';
import '../../../data/remote/network/source/article/article_remote_data_source.dart';
import '../../../data/remote/network/source/article/article_remote_data_source_impl.dart';
import '../../../data/repository/article/article_repository.dart';
import '../../../data/repository/article/article_repository_impl.dart';
import '../../../data/repository/articleLocal/article_local_repository.dart';
import '../../../data/repository/articleLocal/article_local_repository_impl.dart';
import '../../../domain/usecase/article/get_article_use_case.dart';
import '../../../domain/usecase/article/load_local_article_use_case.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    /// 모든 객체는 dependencies에서 의존성 주입을 미리 할 것이기 때문에, 생성자의 파라미터에는 Get.find()만 넣어주어도 충분하다.
    Get.lazyPut<HomeViewModel>(() => HomeViewModel(
        Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));

    // Get.lazyPut(() => GetArticleUseCase(Get.find()), fenix: true);
    //
    // Get.lazyPut<ArticleRepository>(
    //   () => ArticleRepositoryImpl(Get.find()),
    //   fenix: true, //fenix 다시 불러올 때 문제가 생김.
    // );
    //
    // Get.lazyPut<ArticleRemoteDataSource>(
    //   () => ArticleRemoteDataSourceImpl(Get.find()),
    //   fenix: true,
    // );
    //
    // Get.lazyPut(() => ArticleApi(Get.find<Dio>()), fenix: true);
    //
    // Get.lazyPut(() => Dio());
    //
    // Get.lazyPut(() => LoadLocalArticleUseCase(Get.find()));
    //
    // Get.lazyPut<ArticleLocalDataSource>(
    //     () => ArticleLocalDataSourceImpl(Get.find()),
    //     fenix: true);
    // Get.lazyPut<ArticleLocalRepository>(
    //     () => ArticleLocalRepositoryImpl(Get.find()),
    //     fenix: true);
    //
    // Get.lazyPut(() => ArticleDao(Get.find()), fenix: true);

    // Get.lazyPut(() => Get.find<AppDatabase>().articleBox, fenix: true);
  }
}
