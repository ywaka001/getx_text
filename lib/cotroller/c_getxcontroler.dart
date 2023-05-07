import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test/model/m_dropdown.dart';

class ClsGetxController extends GetxController {
  final drpdwnsetting = DrpDwnSetting();
  final drpdwnsetting2 = DrpDwnSetting2().obs;
  final user = User().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // drp2
    drpdwnsetting2.update((drpdwnsetting2) {
      drpdwnsetting2?.label2 = 'ラベル';
      drpdwnsetting2?.lists2 = ['', '1', '2'];
      drpdwnsetting2?.dropdownValue2 = '1';
      drpdwnsetting2?.onChangedCallBack2 = (val) {
        drpdwnsetting2.dropdownValue2 = val;
        print(drpdwnsetting2.dropdownValue2);
      };
    });
    // drpdwnsetting2(DrpDwnSetting2(
    //     label: '',
    //     lists: ['', '1', '2'],
    //     dropdownValue: '1',
    //     onChangedCallBack: (val) {
    //       drpdwnsetting.dropdownValue.value = val;
    //     }));
    //
    // user.update((user) {
    //   // このパラメーターは更新するオブジェクトそのもの
    //   user?.name = 'Jonny';
    // });
    user(User(name: 'João'));
    // dropdown 初期化
    drpdwnsetting.label.value = 'ラベル';
    drpdwnsetting.lists.value = ['', '1', '2'];
    drpdwnsetting.dropdownValue.value = '1';
    drpdwnsetting.onChangedCallBack = (val) {
      user.update((user) {
        user?.name = 'Ken';
      });
      drpdwnsetting.dropdownValue.value = val;
      print('dropdown==>>');
    };
  }
}
