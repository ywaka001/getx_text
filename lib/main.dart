import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_test/component/w_dropdown.dart';
import 'package:getx_test/cotroller/c_getxcontroler.dart';
import 'package:getx_test/component/w_drpdwnwidget2.dart';
import 'package:get/get_connect.dart';

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

GlobalKey globalKey = GlobalKey(); //←これが重要

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
        child: Flex(
          direction: Axis.vertical,
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
            PositionedContainer(
              height: 50,
              onPositionChanged: (position) {
                print('$position');
              },
            ),
            GestureDetector(
              onTap: () {
                print('test');
              },
              onTapDown: (TapDownDetails details) {
                print(details.globalPosition);
              },
              child: Container(
                child: Text('座標'),
                width: 100,
                height: 100,
                color: Colors.red,
              ),
            ),
            ElevatedButton(
                key: globalKey, //←知りたいWidgetにGlobalKeyをセット
                onPressed: () {
                  //↓変数はRenderBoxで宣言（.findRenderObject()で帰ってくるのは"RenderObject"のため
                  RenderBox box =
                      globalKey.currentContext!.findRenderObject() as RenderBox;
                  print("ウィジェットのサイズ :${box.size}");
                  print("ウィジェットの位置 :${box.localToGlobal(Offset.zero)}");
                  dynamic rst = UserProvider()
                      .getUser()
                      .then((value) => print('data==>>$value'));
                  print(rst);
                },
                child: Text('get')),
            ElevatedButton(
                onPressed: () async {
                  final socket = UserProvider().userMessages();
                  socket.onOpen(() {
                    socket.send('データ');
                  });
                  // socket.send('データ3');

                  socket.connect();
                  socket.onMessage((val) {
                    print('onM===>>${val}');
                    socket.close();
                  });
                  socket.onClose((p0) {
                    print('close==>${p0.reason} : ${p0.message} ');
                  });
                  // print('onclose start');
                  // socket.onClose((p0) {
                  //   print('close==>${p0.reason}');
                  // });
                  //
                  //
                  // socket.onOpen(() {
                  //   socket.send('データ');
                  // });
                  //
                  // socket.onMessage((val) {
                  //   print('===>>$val');
                  // });
                  // socket.onClose((p0) {
                  //   print('close==>$p0');
                  // });
                },
                child: Text('socket')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  print('socket only start');
                  GetSocket socket = UserProvider().userMessages();
                  socket.onOpen(() {
                    socket.send('aaaaaaaaaaaaaaaaa');
                  });
                  socket.connect().then((value) => socket.close());
                  print(socket);
                },
                child: Text('socket close')),
          ],
        ),
      ),
    );
  }
}

class UserProvider extends GetConnect {
  // Get リクエスト

  Future<dynamic> getUser() async {
    final data = await rootBundle.load('assets/certificate.crt');
    final certificate = data.buffer.asUint8List();
    final url = 'https://127.0.0.1:5000/';

    // final dynamic response = await get('https://127.0.0.1:5000/');
    final encodedCertificate = base64Encode(certificate);
    final dynamic response =
        await get(url, headers: {'certificate': encodedCertificate});

    if (response.status.hasError) {
      print('err');
      return Future.error(response.statusText);
    } else {
      print('OK');
      return response.body;
    }
  }

  @override
  void onInit() {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // 自己証明書を受け入れる
      return true;
    };
  }

  // Future<Response> getUser() => get('http://127.0.0.1/fruits');
  // Post リクエスト
  // Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
  // File付き Post リクエスト
  // Future<Response<CasesModel>> postCases(List<int> image) {
  //   final form = FormData({
  //     'file': MultipartFile(image, filename: 'avatar.png'),
  //     'otherFile': MultipartFile(image, filename: 'cover.png'),
  //   });
  //   return post('http://youapi/users/upload', form);
  // }

  GetSocket userMessages() {
    return socket('http://localhost:5000/socket');
  }
}

class PositionedContainer extends StatelessWidget {
  const PositionedContainer(
      {required this.height, required this.onPositionChanged});

  final double height;
  final ValueChanged<Offset> onPositionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.blue,
      child: GestureDetector(
        onTap: () {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset containerPosition = renderBox.localToGlobal(Offset.zero);
          onPositionChanged(containerPosition);
        },
        child: Center(
          child: Text(
            'Container',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
