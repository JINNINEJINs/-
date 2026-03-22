import 'package:flutter/material.dart';
import 'webview_page.dart';

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({super.key});

  @override
  State<ApiKeyPage> createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends State<ApiKeyPage> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _obscure = true;
  String? _error;
  late AnimationController _anim;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _handleEnter() {
    final key = _controller.text.trim();
    if (key.isEmpty) { setState(() => _error = 'กรุณากรอก API Key ก่อน'); return; }
    if (!key.startsWith('sk-ant-')) {
      setState(() => _error = 'รูปแบบไม่ถูกต้อง — ต้องขึ้นต้นด้วย sk-ant-...');
      return;
    }
    _navigate(key, false);
  }

  void _navigate(String key, bool demo) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AiWebViewPage(apiKey: key, demoMode: demo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: _buildCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 80, offset: const Offset(0, 32))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: const Color(0xFF6366f1).withOpacity(0.4), blurRadius: 32, offset: const Offset(0, 12))],
            ),
            child: const Icon(Icons.front_hand_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),

          // Title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFa78bfa), Color(0xFF60a5fa)],
            ).createShader(bounds),
            child: const Text('HandAI', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
          ),
          const SizedBox(height: 6),
          Text('Thai Sign Language Detection',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 28),

          // Badges
          Wrap(
            spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
            children: [
              _badge(Icons.visibility_rounded, 'Real-time Vision AI', const Color(0xFFa78bfa)),
              _badge(Icons.camera_alt_rounded, 'Live Camera', const Color(0xFF60a5fa)),
              _badge(Icons.verified_rounded, 'Claude Powered', const Color(0xFF34d399)),
            ],
          ),
          const SizedBox(height: 32),

          // Label
          Align(
            alignment: Alignment.centerLeft,
            child: Text('ANTHROPIC API KEY',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
          ),
          const SizedBox(height: 8),

          // Input
          TextField(
            controller: _controller,
            obscureText: _obscure,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onSubmitted: (_) => _handleEnter(),
            decoration: InputDecoration(
              hintText: 'sk-ant-api03-...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.15))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.15))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF818cf8), width: 1.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: Colors.white.withOpacity(0.4), size: 20),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Key จะถูกเก็บใน session เท่านั้น',
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
          ),

          // Error
          if (_error != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Text(_error!, style: const TextStyle(color: Color(0xFFfca5a5), fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
          const SizedBox(height: 16),

          // Enter button
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: const Color(0xFF6366f1).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: ElevatedButton(
                onPressed: _handleEnter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Enter App →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Demo mode
          TextButton(
            onPressed: () => _navigate('', true),
            child: Text('ไม่มี API Key? ลองโหมด Demo →',
                style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Colors.white.withOpacity(0.35))),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
