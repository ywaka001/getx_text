import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test/cotroller/xy_comtroller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // title: "ListView.builder",
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        // home : new ListViewBuilder(), NO Need To Use Unnecessary New Keyword
        home: const ListViewBuilder());
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListViewBoxController lstVCtrl = Get.put(ListViewBoxController());
    return Scaffold(
      // appBar: AppBar(title: const Text("ListView.builder")),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: 50,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: ListContainer(
                    index: index,
                  ),
                );
              }),
          Obx(() => lstVCtrl.show.value
              ? Positioned(
                  // 位置合わせ
                  top: lstVCtrl.top.value - 1,
                  left: lstVCtrl.left.value + 49,
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(
                          width: 1,
                        )),
                    child: Text('aaaaaaaa${lstVCtrl.top.value}'),
                  ),
                )
              : Container()),
        ],
      ),
    );
  }
}

class ListContainer extends StatelessWidget {
  const ListContainer({super.key, required this.index});

  final index;

  @override
  Widget build(BuildContext context) {
    ListViewBoxController lstVCtrl = Get.find();
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            height: 50,
            width: 50,
            child: Text('No.$index'),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            height: 50,
            width: 200,
            child: Text('商品'),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            height: 50,
            width: 50,
            child: BtnWidget(
              onPositionChanged: (pos) {
                print(pos);
                lstVCtrl.top.value = pos.dy;
                lstVCtrl.left.value = pos.dx;
                lstVCtrl.show.value = !lstVCtrl.show.value;
              },
            ),
          )
        ],
      ),
    );
  }
}

class BtnWidget extends StatelessWidget {
  const BtnWidget({super.key, required this.onPositionChanged});

  final ValueChanged<Offset> onPositionChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('ボタンを押された');
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset containerPosition = renderBox.localToGlobal(Offset.zero);
        onPositionChanged(containerPosition);
      },
      child: Container(
        child: Text('ボタン'),
      ),
    );
  }
}
