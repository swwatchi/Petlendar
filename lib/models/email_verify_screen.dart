import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../login_screen.dart';

class EmailVerifyScreen extends StatefulWidget {
  final String email;
  final String password;

  const EmailVerifyScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  bool _isSending = false;
  bool _isChecking = false;
  bool _isVerified = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 인증 확인 타이머만 실행 (메일 재전송은 버튼 클릭으로만)
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _checkVerified());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerified() async {
    setState(() => _isChecking = true);
    try {
      final res = await http.post(
        Uri.parse(
          'https://mljwvknbhwgtcbwbmimh.supabase.co/functions/v1/database-access',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'check_email_verification',
          'email': widget.email,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>? ?? {};
        if (mounted) setState(() => _isVerified = data['isVerified'] ?? false);
      }
    } catch (e) {
      // 필요시 로그
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  Future<void> _resendEmail() async {
    setState(() => _isSending = true);
    try {
      final res = await http.post(
        Uri.parse(
          'https://mljwvknbhwgtcbwbmimh.supabase.co/functions/v1/database-access',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'resend_verification',
          'email': widget.email,
          'password': widget.password,
        }),
      );

      if (res.statusCode == 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("인증 메일이 발송되었습니다.")),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("인증 메일 재전송에 실패했습니다.")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("재전송 실패: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _finishSignup() {
    if (!_isVerified) return;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입 완료! 로그인 해주세요.")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이메일 인증")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.email} 주소로 인증 메일을 보냈습니다.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _isVerified
                    ? "이메일 인증 완료 ✅"
                    : "메일함에서 인증 메일을 확인해주세요.",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSending ? null : _resendEmail,
                child: _isSending
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("인증 메일 다시 보내기"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isVerified ? _finishSignup : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVerified ? Colors.blue : Colors.grey.shade400,
                ),
                child: _isChecking
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("회원가입 완료"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}