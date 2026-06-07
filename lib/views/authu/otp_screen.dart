import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mgcollection_app/views/admin/screens/admin_home.dart';
import 'package:mgcollection_app/views/user/screens/bottomnavigationbarScreen.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final supabase = Supabase.instance.client;

  // 6 separate controllers for each digit
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  bool loading = false;
  bool resending = false;

  // Resend cooldown
  int _resendCountdown = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _resendCountdown = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String get _otpCode =>
      _controllers.map((c) => c.text).join();

  Future<void> verifyOtp() async {
    final otp = _otpCode;

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await supabase.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.email,
      );

      if (response.user == null) {
        throw Exception('Verification failed');
      }

      // ✅ Check blocked + role after OTP verified
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (!mounted) return;

      if (userData == null) {
        // First time — create user row
        await supabase.from('users').insert({
          'id': response.user!.id,
          'email': response.user!.email,
          'role': 'user',
          'blocked': false,
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => const Bottomnavigationbarscreen()),
          (_) => false,
        );
        return;
      }

      if (userData['blocked'] == true) {
        await supabase.auth.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Your account has been blocked by the admin')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
        return;
      }

      if (userData['role'] == 'admin') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AdminHome()),
          (_) => false,
        );
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => const Bottomnavigationbarscreen()),
        (_) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
      // Clear fields on wrong OTP
      for (final c in _controllers) c.clear();
      _focusNodes[0].requestFocus();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> resendOtp() async {
    if (_resendCountdown > 0) return;

    setState(() => resending = true);

    try {
      await supabase.auth.signInWithOtp(email: widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent to your email ✅')),
      );
      _startCountdown();
      // Clear all fields
      for (final c in _controllers) c.clear();
      _focusNodes[0].requestFocus();
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => resending = false);
    }
  }

  // Auto-focus next field when a digit is entered
  void _onDigitChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    // Auto-submit when all 6 digits filled
    if (_otpCode.length == 6) {
      verifyOtp();
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFEF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── BACK BUTTON ──
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new),
                ),
              ),

              const SizedBox(height: 50),

              // ── HEADER ──
              const Text(
                "OTP Verification",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Enter the 6-digit code sent to",
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 50),

              // ── 6 OTP BOXES ──
              // ── 6 OTP BOXES ──
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: List.generate(6, (index) {
    return SizedBox(
      width: 48,
      height: 58,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF5DA9E9),
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty && index > 0) {
            // ✅ backspace — go to previous field
            _focusNodes[index - 1].requestFocus();
          } else if (value.length == 1 && index < 5) {
            // ✅ digit entered — go to next field
            _focusNodes[index + 1].requestFocus();
          }
          // ✅ auto-submit when all 6 filled
          if (_otpCode.length == 6) {
            verifyOtp();
          }
        },
      ),
    );
  }),
),

              const SizedBox(height: 50),

              // ── VERIFY BUTTON ──
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DA9E9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  onPressed: loading ? null : verifyOtp,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // ── RESEND ──
              Center(
                child: GestureDetector(
                  onTap: _resendCountdown == 0 ? resendOtp : null,
                  child: resending
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Didn't receive the code? ",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              TextSpan(
                                text: _resendCountdown > 0
                                    ? "Resend in ${_resendCountdown}s"
                                    : "Resend",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _resendCountdown > 0
                                      ? Colors.grey
                                      : const Color(0xFF5DA9E9),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}