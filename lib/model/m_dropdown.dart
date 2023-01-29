import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrpDwnSetting {
  final label = Rx<String>('');
  final lists = Rx<List<String>>([]);
  Function? onChangedCallBack;
  final dropdownValue = Rx<String>('');

  // final  label = ''.obs;
  // final lists = [].obs;
  // final Function onChangedCallBacka = (() {}).obs;
  // final dropdownValue = ''.obs;
}

class DrpDwnSetting2 {
  DrpDwnSetting2(
      {this.label = '',
      this.lists,
      this.onChangedCallBack,
      this.dropdownValue = ''});
  String label;
  List<String>? lists;
  Function? onChangedCallBack;
  String dropdownValue;
}

class User {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}
