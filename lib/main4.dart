import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SSL GET Request'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: makeGetRequest,
            child: const Text('Make GET Request'),
          ),
        ),
      ),
    );
  }
}

// 証明書ロード
Future<Uint8List> loadCertificate() async {
  final data = await rootBundle.load('assets/certificates/certificate.crt');
  return data.buffer.asUint8List();
}

// リクエスト
Future<void> makeGetRequest() async {
  final certificate = await loadCertificate();
  final httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  final uri = Uri.parse('https://127.0.0.1:5000');

  try {
    final request = await httpClient.getUrl(uri);
    request.headers.add('certificate', base64Encode(certificate));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    // レスポンスの処理
    print(responseBody);
  } catch (error) {
    // エラーハンドリング
    print('Error: $error');
  }
}
