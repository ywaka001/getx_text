import 'dart:convert';

import 'package:get/get.dart';

class Main3Controller extends GetxController {
  List<MyConstructor> dataList = [];
  String dataJsonString = '';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    dataList.add(MyConstructor(strNm: '商品１', intPrice: 500));
    dataList.add(MyConstructor(strNm: '商品２', intPrice: 1500));
    dataList.add(MyConstructor(strNm: '商品３', intPrice: 3000));

    List<Map<String, dynamic>> dataJsonList =
        dataList.map((e) => e.toMap()).toList(); // マップに変換し、リストに追加
    dataJsonString = jsonEncode(dataJsonList); //

    // List<Map<String, dynamic>> dataDecode =
    //     jsonDecode(dataJsonString).cast<Map<String, dynamic>>();
    //
    // List<MyConstructor> dataDecodeList =
    //     dataDecode.map((e) => MyConstructor.fromMap(e)).toList();

    // JSON文字列に変換
  }
}

class MyConstructor {
  final String strNm;
  final int intPrice;

  MyConstructor({required this.strNm, required this.intPrice});

  factory MyConstructor.fromMap(Map<String, dynamic> map) => MyConstructor(
        strNm: map['strNm'],
        intPrice: map['intPrice'],
      );

  Map<String, dynamic> toMap() => {
        'strNm': strNm,
        'intPrice': intPrice,
      };
}
