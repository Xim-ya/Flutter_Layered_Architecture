import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:retrofitpractice/app/routes/app_pages.dart';
import 'package:retrofitpractice/domain/models/article/article_model.dart';
import 'package:retrofitpractice/domain/usecase/article/get_article_use_case.dart';
import 'package:retrofitpractice/ui/common/base/base_view_model.dart';
import '../../common/componets/common_widget.dart';

enum LoadingStatus { done, empty }

class HomeViewModel extends BaseViewModel {
  final GetArticleUseCase _useCase;
  String _selectedNation = "kr";
  int? selectedIndex;
  final Rxn<ArticleModel> _data = Rxn();
  HomeViewModel(this._useCase);

  // 선택된 Query을 기준으로 Network 호출
  void fetchArticles() async {
    final responseResult = await _useCase.call(_selectedNation);
    responseResult.fold(onSuccess: (data) {
      _data.value = data;
    }, onFailure: (e) {
      final errorResponse = e as DioError;

      print("---------[에러] : ${errorResponse.type}");
      CommonWidget.toast('기사 정보를 불러올 수 없습니다');
    });
  }

  void fetchNewsOnNation(String nation) async {
    if (nation == _selectedNation) {
      return CommonWidget.toast("이미 선택된 국가 입니다");
    }
    _selectedNation = nation;
    fetchArticles();
  }

  @override
  void onInit() async {
    super.onInit();
    fetchArticles();
  }

  void test() {}

  void routeToDetail(int selectedIndex) {
    this.selectedIndex = selectedIndex;
    navigation.open(Routes.articleDetail);
  }

  ArticleCoreModel? get selectedArticle {
    return _data.value!.articles[selectedIndex!];
  }

  // Format Instance, Nested Json(result data)를 쉽게 받아오기 위함.
  ArticleModel? get rootData => _data.value;
  List<ArticleCoreModel> get data => _data.value!.articles;
}
