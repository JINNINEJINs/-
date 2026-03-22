import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class AiWebViewPage extends StatefulWidget {
  final String apiKey;
  final bool demoMode;

  const AiWebViewPage({super.key, required this.apiKey, this.demoMode = false});

  @override
  State<AiWebViewPage> createState() => _AiWebViewPageState();
}

class _AiWebViewPageState extends State<AiWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => _injectAndStart(),
        onWebResourceError: (e) => debugPrint('WebView error: ${e.description}'),
      ))
      ..loadFlutterAsset('assets/demo.html');

    // Grant camera permission for Android WebView
    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController)
          .setOnPlatformPermissionRequest((request) => request.grant());
    }
  }

  Future<void> _injectAndStart() async {
    // Sanitize the API key to prevent JS injection
    final safeKey = widget.apiKey.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
    final demo = widget.demoMode ? 'true' : 'false';

    await _controller.runJavaScript('''
      (function() {
        window.apiKey = '$safeKey';
        window.isDemoMode = $demo;
        // Hide API screen, show app
        var apiScreen = document.getElementById('apiScreen');
        if (apiScreen) apiScreen.style.display = 'none';
        var appScreen = document.getElementById('appScreen');
        if (appScreen) {
          appScreen.classList.remove('hidden');
          appScreen.style.display = 'flex';
        }
        // Start app state
        if ($demo) {
          var tag = document.getElementById('modeTag');
          if (tag) tag.style.display = 'flex';
          var ml = document.getElementById('modeLabel');
          if (ml) ml.textContent = 'Demo';
          var el = document.getElementById('engineLabel');
          if (el) el.textContent = 'Simulated';
          if (typeof setStatus === 'function') setStatus('Demo Mode', 'connected');
          if (typeof startAutoDemo === 'function') startAutoDemo();
        } else {
          var el = document.getElementById('engineLabel');
          if (el) el.textContent = 'Claude Haiku';
          if (typeof setStatus === 'function') setStatus('Camera ready', 'connected');
        }
        if (typeof startCamera === 'function') startCamera();
      })();
    ''');

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0c29),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              Container(
                color: const Color(0xFF0f0c29),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF6366f1)),
                      SizedBox(height: 16),
                      Text('Loading HandAI...', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
