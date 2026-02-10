import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AiWebViewPage extends StatefulWidget {
  const AiWebViewPage({super.key});

  @override
  State<AiWebViewPage> createState() => _AiWebViewPageState();
}

class _AiWebViewPageState extends State<AiWebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          // 🔴 เปลี่ยนเป็น URL เว็บของคุณ
         'https://www.beingstory.com/'
          // หรือ ngrok / IP เครื่อง
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thai Sign Language AI'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
