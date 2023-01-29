import 'package:flutter/material.dart';
import 'package:get/get.dart';

// https://gist.github.com/xErik/71d006f9334512a415f63a255844d13e

class User {
  final name = ''.obs;
  final last = ''.obs;
  final age = 0.obs;
}

class Controller extends GetxController {
  var items = <String>['a'].obs;
  var itemCurrent = 'a'.obs;
  addItem(String item) => items.add(item);

  final user = User();
}

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {
  final Controller c = Get.put(Controller());

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(),
        body: MyDropdown(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              c.addItem((c.items.length + 1).toString());
            }));
  }
}

class MyDropdown extends StatelessWidget {
  @override
  Widget build(context) {
    final Controller c = Get.find();

    return Column(
      children: [
        Obx(() => Text(">>>${c.user.age}")),
        Obx(() => DropdownButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            value: c.itemCurrent.value,
            items: c.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (item) {
              c.itemCurrent.value = item!;
              c.user.age.value += 1;
              print(c.user.age);
            })),
      ],
    );
  }
}
