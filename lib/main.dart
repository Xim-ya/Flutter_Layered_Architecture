import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:retrofitpractice/app/di/app_binding.dart';
import 'package:retrofitpractice/app/routes/app_pages.dart';
import 'app/config/equatable_config.dart';
import 'app/config/http_config.dart';
import 'app/config/loading_config.dart';
import 'app/config/size_config.dart';
import 'data/local/persistence/hive/app_data_base.dart';

/* Dart Pad */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // debug 빌드에서만 http certification 설정
  if (kDebugMode) {
    HttpOverrides.global = AppHttpOverrides();
  }

  // 앱 설정 init
  AppLoadingConfig.init();
  AppEquatableConfig.init();
  runApp(const MyApp());

  initDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      enableLog: true,
      initialRoute: Routes.home,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
      builder: (context, child) {
        SizeConfig().init(context);
        return EasyLoading.init()(context, child);
      },
    );
  }
}

/// main() 함수에서 사용할, 미리 주입하는 dependencies 모음
Future<void> initDependencies() async {
  // Splash에서 쓸 인스턴스들만 미리 따로 빼서 등록함.
  await Get.putAsync(AppDatabase.init, permanent: true);

  await Get.putAsync(
    () => Get.find<AppDatabase>().articleBox,
    permanent: true,
  );
}
