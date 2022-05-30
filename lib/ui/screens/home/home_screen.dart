import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:retrofitpractice/ui/common/base/base_screen.dart';
import 'package:retrofitpractice/ui/screens/home/home_view_model.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      return Container(
        /// data가 null이냐 아니냐에 따라 로딩 처리
        child: (vm.data == null)
            ? const CircularProgressIndicator()
            : Text(
                vm.data!.title!,
              ),
      );
    });
  }
}
