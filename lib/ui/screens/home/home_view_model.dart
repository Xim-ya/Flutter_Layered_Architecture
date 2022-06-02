import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:retrofitpractice/app/routes/app_pages.dart';
import 'package:retrofitpractice/data/local/persistence/dao/article/document/article_document.dart';
import 'package:retrofitpractice/domain/enums/acrticle_status.dart';
import 'package:retrofitpractice/domain/models/article/article_model.dart';
import 'package:retrofitpractice/domain/usecase/article/delete_local_article_use_case.dart';
import 'package:retrofitpractice/domain/usecase/article/get_article_use_case.dart';
import 'package:retrofitpractice/domain/usecase/article/load_local_article_use_case.dart';
import 'package:retrofitpractice/domain/usecase/article/add_local_article_use_case.dart';
import 'package:retrofitpractice/ui/common/base/base_view_model.dart';
import '../../../domain/usecase/article/delete_all_local_article_use_case.dart';
import '../../common/componets/common_widget.dart';

class HomeViewModel extends BaseViewModel {
  String _selectedNation = "kr";
  int? selectedIndex;

  final GetArticleUseCase _useCase;
  final LoadLocalArticleUseCase _loadLocalArticleUseCase;
  final AddLocalArticleUseCase _addLocalArticleUseCase;
  final DeleteAllLocalArticleUseCase _deleteAllLocalArticleUseCase;
  final DeleteLocalArticleUseCase _deleteLocalArticleUseCase;

  Rxn<ArticleModel> _data = Rxn();
  Box<ArticleDocument>? _localData;

  HomeViewModel(
      this._useCase,
      this._loadLocalArticleUseCase,
      this._addLocalArticleUseCase,
      this._deleteAllLocalArticleUseCase,
      this._deleteLocalArticleUseCase);

  /* Local Database 로직 */
  void deleteAllLocalArticle() {
    _deleteAllLocalArticleUseCase.call();
  }

  void deleteLocalArticle(int index) {
    _deleteLocalArticleUseCase.call(index);
    update();
  }

  void fetchLocalArticles() {
    final responseResult = _loadLocalArticleUseCase.call();
    _localData = responseResult;
  }

  void addArticleToLocalDataBase(ArticleCoreModel request) {
    final aim = _localData?.values
        .where((e) => e.id == "${request.url}${request.publishedAt}");
    if (aim!.isNotEmpty) {
      return CommonWidget.toast("이미 추가한 기사 입니다.");
    }
    _addLocalArticleUseCase.call(request);
  }

  // 선택된 Query을 기준으로 Network 호출
  void fetchArticles() async {
    final responseResult = await _useCase.call(_selectedNation);
    responseResult.fold(onSuccess: (data) {
      _data.value = data;
    }, onFailure: (e) {
      // TODO: Error 자체를 모두 toast에 보내는게 맞는지
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

  void routeToFavorite() => navigation.open(Routes.articleFavorite);

  void routeToDetail(int selectedIndex) {
    this.selectedIndex = selectedIndex;
    navigation.open(Routes.articleDetail);
  }

  @override
  void onInit() async {
    super.onInit();
    fetchArticles();
    fetchLocalArticles();
  }

  ArticleCoreModel? get selectedArticle =>
      _data.value!.articles[selectedIndex!];
  Box<ArticleDocument>? get localData => _localData;
  ArticleModel? get rootData => _data.value;
  List<ArticleCoreModel> get data => _data.value!.articles;
}
