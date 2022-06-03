import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:retrofitpractice/app/routes/app_pages.dart';
import 'package:retrofitpractice/data/local/persistence/dao/article/document/article_document.dart';
import 'package:retrofitpractice/domain/models/article/article_model.dart';
import 'package:retrofitpractice/domain/usecase/article/delete_local_article_use_case.dart';
import 'package:retrofitpractice/domain/usecase/article/get_article_use_case.dart';
import 'package:retrofitpractice/domain/usecase/article/load_local_article_use_case.dart';
import 'package:retrofitpractice/domain/usecase/article/add_local_article_use_case.dart';
import 'package:retrofitpractice/ui/common/base/base_view_model.dart';
import '../../../domain/usecase/article/delete_all_local_article_use_case.dart';
import '../../common/componets/common_widget.dart';

class HomeViewModel extends BaseViewModel {
  /* State Variables */
  String _selectedNation = "kr"; // 기본 국가 설정 값
  int? selectedIndex; // 선택된 기사의 인덱스 값, 인덱스 값으로 기사의 상세 페이지를 보여줌

  /* `UseCase` 연동 */
  final GetArticleUseCase _useCase;
  final LoadLocalArticleUseCase _loadLocalArticleUseCase;
  final AddLocalArticleUseCase _addLocalArticleUseCase;
  final DeleteAllLocalArticleUseCase _deleteAllLocalArticleUseCase;
  final DeleteLocalArticleUseCase _deleteLocalArticleUseCase;

  /* 인스턴스 초기화 */
  Rxn<ArticleModel> _data = Rxn();
  Box<ArticleDocument>? _localData;

  HomeViewModel(
      this._useCase,
      this._loadLocalArticleUseCase,
      this._addLocalArticleUseCase,
      this._deleteAllLocalArticleUseCase,
      this._deleteLocalArticleUseCase);

  /*** Local Database 관련 로직  로직 ***/
  /// 로컬에 저장된 모든 기사 지우기
  void deleteAllLocalArticle() {
    _deleteAllLocalArticleUseCase.call();
    Get.back();
  }

  /// 로컬에 저장된 특정 기사 지우기
  void deleteLocalArticle(int index) {
    _deleteLocalArticleUseCase.call(index);
    update();
  }

  /// 로컬에 저장된 기사 불러오기
  void fetchLocalArticles() {
    final responseResult = _loadLocalArticleUseCase.call();
    _localData = responseResult;
  }

  /// 로컬에 즐겨찾기 기사 추가하기
  void addArticleToLocalDataBase(ArticleCoreModel request) {
    // 기존에 추가한 기사가 있다면 로컬에 추가하지 않음.
    final aim = _localData?.values
        .where((e) => e.id == "${request.url}${request.publishedAt}");
    if (aim!.isNotEmpty) {
      return CommonWidget.toast("이미 추가한 기사 입니다.");
    }
    _addLocalArticleUseCase.call(request);
  }

  /*** 네트워킹 로직 ***/
  /// 선택된 Query을 기준으로 Network 호출
  void fetchArticles() async {
    final responseResult = await _useCase.call(_selectedNation);
    responseResult.fold(onSuccess: (data) {
      _data.value = data;
    }, onFailure: (e) {
      // TODO: Error 자체를 모두 toast에 보내는게 맞는지
      CommonWidget.toast('기사 정보를 불러올 수 없습니다');
    });
  }

  /// 기사 국가 설정을 변경하여 데이터 호출
  void fetchNewsOnNation(String nation) async {
    if (nation == _selectedNation) {
      return CommonWidget.toast("이미 선택된 국가 입니다");
    }
    _selectedNation = nation;
    fetchArticles();
  }

  /*** 라우팅 로직 ***/
  /// 즐겨찾기 스크린으로 이동
  void routeToFavorite() => navigation.open(Routes.articleFavorite);

  /// 기사 상세페이지로 이동
  void routeToDetail(int selectedIndex) {
    this.selectedIndex = selectedIndex;
    navigation.open(Routes.articleDetail);
  }

  @override
  void onInit() async {
    super.onInit();
    fetchArticles(); // 서버에서 기사 리스트 호출
    fetchLocalArticles(); // 로컬에서 기사 리스트 호출
  }

  /*** 데이터 불러오는 Getter 값 ***/
  ArticleCoreModel? get selectedArticle =>
      _data.value!.articles[selectedIndex!];
  Box<ArticleDocument>? get localData => _localData;
  ArticleModel? get rootData => _data.value;
  List<ArticleCoreModel> get data => _data.value!.articles;
}
