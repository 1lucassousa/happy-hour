// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:happy_hour/modules/presenter/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => Dio()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const HomePage()),
      ];
}
