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
            ElevatedButton(
                onPressed: () {
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
    final dynamic response = await get('http://127.0.0.1:5000/');
    if (response.status.hasError) {
      print('err');
      return Future.error(response.statusText);
    } else {
      print('OK');
      return response.body;
    }
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
