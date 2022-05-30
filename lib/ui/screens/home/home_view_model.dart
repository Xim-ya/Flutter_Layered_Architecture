import 'package:get/get.dart';
import 'package:retrofitpractice/data/remote/network/api/article/response/article_response.dart';
import 'package:retrofitpractice/domain/models/article/article_model.dart';
import 'package:retrofitpractice/domain/usecase/article/get_article_use_case.dart';
import 'package:retrofitpractice/ui/common/base/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  final GetArticleUseCase _useCase;
  Rxn<ArticleModel> _data = Rxn();
  //
  HomeViewModel(this._useCase);

  void testFunction() {
    print(data?.title);
  }

  void networking() async {
    final responseResult = await _useCase.call();
    print(responseResult);
  }

  @override
  void onInit() async {
    super.onInit();
    final responseResult = await _useCase.call();
    responseResult.fold(onSuccess: (data) {
      _data.value = data;
    }, onFailure: (error) {
      //Exception 처리 필요
    });
  }

  ArticleModel? get data => _data.value;
}
