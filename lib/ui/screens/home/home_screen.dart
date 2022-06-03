import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retrofitpractice/app/resources/colors/colors.dart';
import 'package:retrofitpractice/app/resources/dimensions/insets.dart';
import 'package:retrofitpractice/app/resources/strings/font.dart';
import 'package:retrofitpractice/domain/enums/nation_type.dart';
import 'package:retrofitpractice/ui/common/base/base_screen.dart';
import 'package:retrofitpractice/ui/screens/home/view/article_card.dart';
import 'package:retrofitpractice/ui/screens/home/view/article_card_skeleton.dart';
import 'package:retrofitpractice/ui/screens/home/home_view_model.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.wh,
      title: Text("News", style: AppTextStyle.body1R1626),
      actions: [
        /* 팝업 메뉴 버튼 (뉴스 국가 설정) */
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
    /* 즐겨찾기 뉴스 스크린으로 이동하는 `FloatingButton` */
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
            /* 서버로부터 받은 데이터가 없을 때 `SkeletonView`를 보여줌 */
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
