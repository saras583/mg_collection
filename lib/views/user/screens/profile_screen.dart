import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/authu/login_screen.dart';
import 'package:mgcollection_app/views/user/screens/theme.dart';
import 'package:mgcollection_app/services/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? userData;
  bool loadingProfile = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      setState(() {
        userData = data;
        loadingProfile = false;
      });
    } catch (e) {
      setState(() => loadingProfile = false);
      print('Error fetching user: $e');
    }
  }

  // Generates initials from name or email
  String _getInitials() {
    final name = userData?['name'];
    final email = userData?['email'] ?? '';

    if (name != null && name.toString().trim().isNotEmpty) {
      final parts = name.toString().trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return parts[0][0].toUpperCase();
    }

    // Fallback to first letter of email
    return email.isNotEmpty ? email[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: loadingProfile
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Account & Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Profile card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            // Initials avatar
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: const Color(0xFFB5D4F4),
                              child: Text(
                                _getInitials(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0C447C),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Name
                            Text(
                              userData?['name'] ?? 'No name set',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Email
                            Text(
                              userData?['email'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Role badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: userData?['role'] == 'admin'
                                    ? const Color(0xFFFAEEDA)
                                    : const Color(0xFFEAF3DE),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                userData?['role'] ?? 'user',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: userData?['role'] == 'admin'
                                      ? const Color(0xFF854F0B)
                                      : const Color(0xFF3B6D11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Account section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            leading: const Icon(Icons.notifications_outlined),
                            title: const Text('Notification settings'),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(Icons.shopping_cart_outlined),
                            title: const Text('Shipping address'),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(Icons.payment_outlined),
                            title: const Text('Payment info'),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Delete account',
                              style: TextStyle(color: Colors.red),
                            ),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // App settings section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'App Settings',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            value: Provider.of<ThemeProvider>(context)
                                    .themeData ==
                                darkTheme,
                            onChanged: (value) {
                              Provider.of<ThemeProvider>(
                                context,
                                listen: false,
                              ).changeTheme();
                            },
                            title: const Text('Dark mode'),
                          ),
                          SwitchListTile(
                            value: true,
                            onChanged: (val) {},
                            title: const Text('Push notifications'),
                          ),
                          SwitchListTile(
                            value: true,
                            onChanged: (val) {},
                            title: const Text('Location services'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Logout button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Logout',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            await supabase.auth.signOut();
                            if (!context.mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (_) => false,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}