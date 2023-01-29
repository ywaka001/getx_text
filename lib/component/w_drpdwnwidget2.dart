import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test/cotroller/c_getxcontroler.dart';
import 'package:getx_test/db/db_sqflite.dart';
import 'package:getx_test/model/m_dropdown.dart';

class DropDownWidget2 extends StatelessWidget {
  const DropDownWidget2({
    super.key,
    required this.setting,
  });
  final setting;

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>${setting}");

    // final ClsGetxController c = Get.find();
    print('dropdownwidget');
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        // Obx(() => Text(setting.value.label)),
        Container(
          width: 70,
          child: Text(setting.value.label),
        ),
        Container(
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
          child: DropdownButtonHideUnderline(
            child: Obx(() {
              return DropdownButton<String>(
                value: setting.value.dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                items:
                    setting.value.lists.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(item),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setting.value.onChangedCallBack?.call(val);
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
