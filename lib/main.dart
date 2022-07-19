import 'package:flutter/material.dart';
import 'package:super_lawer/router/router.dart';

void main() {
  runApp(SuperLawerApp());
}

class SuperLawerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'super-lawer',
        initialRoute: '/', //初始化加载的路由
        onGenerateRoute: onGenerateRoute);
  }
}
