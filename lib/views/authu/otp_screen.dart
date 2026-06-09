import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgcollection_app/views/admin/screens/admin_home.dart';
import 'package:mgcollection_app/views/authu/login_screen.dart';
import 'package:mgcollection_app/views/user/screens/bottomnavigationbarScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  final supabase = Supabase.instance.client;

  bool loading = false;
  bool resendLoading = false;
  bool _navigating = false;

  int _resendSeconds = 60;
  Timer? _timer;

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();

    setState(() => _resendSeconds = 60);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendSeconds <= 0) {
        timer.cancel();
        return;
      }

      setState(() => _resendSeconds--);
    });
  }

  Future<void> verifyOtp() async {
    if (loading || _navigating) return;

    if (_otp.length < 6) {
      _showSnack('Please enter the complete 6-digit OTP');
      return;
    }

    setState(() => loading = true);

    try {
      final response = await supabase.auth.verifyOTP(
        email: widget.email.trim(),
        token: _otp,
        type: OtpType.email,
      );

      if (!mounted) return;

      if (response.user == null) {
        _showSnack('Invalid or expired OTP. Please try again.');
        _clearOtp();
        return;
      }

      await _handleLoggedInUser(response.user!);
    } on AuthException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
      _clearOtp();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Something went wrong. Please try again.');
      _clearOtp();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> resendOtp() async {
    if (_resendSeconds > 0 || resendLoading) return;

    setState(() => resendLoading = true);

    try {
      await supabase.auth.signInWithOtp(
        email: widget.email.trim(),
        shouldCreateUser: true,
      );

      if (!mounted) return;

      _showSnack('New OTP sent! Check your inbox.', success: true);
      _clearOtp();
      _startResendTimer();
    } on AuthException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Failed to resend. Please try again.');
    } finally {
      if (mounted) setState(() => resendLoading = false);
    }
  }

  Future<void> _handleLoggedInUser(User user) async {
    if (_navigating) return;
    _navigating = true;

    try {
      final metadata = user.userMetadata ?? {};

      final fallbackName =
          metadata['name'] ??
          metadata['full_name'] ??
          metadata['display_name'] ??
          user.email?.split('@').first ??
          widget.email.split('@').first;

      Map<String, dynamic>? userData = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (userData == null) {
        await supabase.from('users').upsert({
          'id': user.id,
          'email': user.email ?? widget.email,
          'name': fallbackName,
          'role': 'user',
          'blocked': false,
        });

        userData = await supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .maybeSingle();
      }

      if (userData == null) {
        throw Exception('Unable to load user profile');
      }

      if (userData['blocked'] == true) {
        await supabase.auth.signOut();

        if (!mounted) return;

        _showSnack('Your account has been blocked by the admin.');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );

        return;
      }

      if (!mounted) return;

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
        MaterialPageRoute(builder: (_) => const Bottomnavigationbarscreen()),
        (_) => false,
      );
    } catch (e) {
      _navigating = false;

      if (!mounted) return;

      _showSnack('Login failed. Please try again.');
    }
  }

  void _clearOtp() {
    for (final controller in _controllers) {
      controller.clear();
    }

    if (mounted) {
      _focusNodes[0].requestFocus();
    }
  }

  void _showSnack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardColor;
    final isDark = theme.brightness == Brightness.dark;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey;
    final scaffoldBg =
        isDark ? const Color(0xFF100F0F) : const Color(0xFFF5EFEF);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: loading ? null : () => Navigator.pop(context),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5DA9E9).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_read_outlined,
                      size: 40,
                      color: Color(0xFF5DA9E9),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    'Check Your Email',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "We've sent a 6-digit OTP to",
                    style: TextStyle(fontSize: 15, color: subtitleColor),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5DA9E9),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => _otpBox(
                        context: context,
                        index: index,
                        cardColor: cardColor,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5DA9E9),
                        disabledBackgroundColor:
                            const Color(0xFF5DA9E9).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      onPressed: loading ? null : verifyOtp,
                      child: loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: _resendSeconds > 0
                        ? Text(
                            'Resend OTP in ${_resendSeconds}s',
                            style: TextStyle(color: subtitleColor),
                          )
                        : GestureDetector(
                            onTap: resendLoading ? null : resendOtp,
                            child: resendLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF5DA9E9),
                                    ),
                                  )
                                : const Text(
                                    "Didn't receive? Resend OTP",
                                    style: TextStyle(
                                      color: Color(0xFF5DA9E9),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpBox({
    required BuildContext context,
    required int index,
    required Color cardColor,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return SizedBox(
      width: 48,
      height: 58,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        enabled: !loading,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: cardColor,
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          if (_otp.length == 6 && !loading) {
            FocusScope.of(context).unfocus();
            verifyOtp();
          }
        },
      ),
    );
  }
}