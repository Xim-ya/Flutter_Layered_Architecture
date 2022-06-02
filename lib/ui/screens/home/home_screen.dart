import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retrofitpractice/app/resources/colors/colors.dart';
import 'package:retrofitpractice/app/resources/dimensions/insets.dart';
import 'package:retrofitpractice/app/resources/strings/font.dart';
import 'package:retrofitpractice/domain/enums/nation_type.dart';
import 'package:retrofitpractice/domain/models/article/article_model.dart';
import 'package:retrofitpractice/ui/common/base/base_screen.dart';
import 'package:retrofitpractice/ui/screens/home/card/article_card_skeleton.dart';
import 'package:retrofitpractice/ui/screens/home/home_view_model.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.wh,
      title: Text("News", style: AppTextStyle.body1R1626),
      actions: [
        /* 팝업 메뉴 버튼 */
        PopupMenuButton(
          icon: const Icon(Icons.more_horiz, color: Colors.black),
          onSelected: (value) {
            String selectedNation = NationDefaults.nation[value]!;
            vm.fetchNewsOnNation(selectedNation);
          },
          itemBuilder: (context) {
            return NationDefaults.nation.keys
                .map(
                  (value) => PopupMenuItem(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList();
          },
        )
      ],
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.favorite_border),
        onPressed: () => vm.routeToFavorite());
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => Container(
        padding: AppInset.horizontal16,
        child: ListView.separated(
          padding: AppInset.top16,
          itemCount: vm.rootData == null ? 5 : vm.data.length,
          itemBuilder: (context, index) {
            if (vm.rootData == null) {
              return const ArticleCardSkeleton();
            }
            final article = vm.data[index];
            return ArticleCard(vm: vm, article: article, index: index);
          },
          separatorBuilder: (_, __) {
            return const Divider();
          },
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  const ArticleCard(
      {Key? key, required this.vm, required this.article, required this.index})
      : super(key: key);

  final HomeViewModel vm;
  final ArticleCoreModel article;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => vm.routeToDetail(index),
      child: SizedBox(
        height: 120,
        child: Row(
          children: [
            /* 뉴스 카드 왼쪽 (Image) */
            AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                /* Image Null 값에 따라 예외처리 */
                /* Image값이 Null이나 "" 비어있는 값을 리턴할 경우를 생각해서 예외처리*/
                /* TODO: [질문] 아래 코드처럼 예외처리를 해서 다른 ViewWidget을 반환해야되는 경우 어떤 레이어에서 아래 기능을 처리하는지. 이렇게 뷰 안에서 예외처리 코드를 작성해도 무관?*/
                child: vm.data[index].urlToImage == null ||
                        vm.data[index].urlToImage == ""
                    ? const Center(
                        child: Icon(Icons.error),
                      )
                    : CachedNetworkImage(
                        placeholder: (context, url) => Shimmer(
                              child: Container(
                                color: AppColor.skeleton,
                              ),
                            ),
                        fit: BoxFit.cover,
                        imageUrl: article.urlToImage!),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /* 기사 제목 */
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      article.title ?? "제목 없음",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.title1R1618,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      article.description ?? "내용 없음",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.title3R1418
                          .copyWith(color: AppColor.gray500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
