import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test/component/w_dropdown.dart';
import 'package:getx_test/cotroller/c_getxcontroler.dart';
import 'package:getx_test/component/w_drpdwnwidget2.dart';
import 'package:getx_test/model/m_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  final ClsGetxController c = Get.put(ClsGetxController());
  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'テスト',
            ),
            DropDownWidget(
              setting: c.drpdwnsetting,
              txtsetting: c.user,
            ),
            DropDownWidget2(setting: c.drpdwnsetting2),
          ],
        ),
      ),
    );
  }
}
