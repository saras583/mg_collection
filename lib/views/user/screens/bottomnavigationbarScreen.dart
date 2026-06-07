import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/authu/login_screen.dart';
import 'package:mgcollection_app/views/user/screens/bestsellers_screen.dart';
import 'package:mgcollection_app/views/user/screens/home_screen.dart';
import 'package:mgcollection_app/views/user/screens/orderbagscreen.dart';
import 'package:mgcollection_app/views/user/screens/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Bottomnavigationbarscreen extends StatefulWidget {
  const Bottomnavigationbarscreen({super.key});

  @override
  State<Bottomnavigationbarscreen> createState() =>
      _BottomnavigationbarscreenState();
}

class _BottomnavigationbarscreenState
    extends State<Bottomnavigationbarscreen> {
  int currentIndex = 0;
  final supabase = Supabase.instance.client;
  RealtimeChannel? _blockChannel;

  // ✅ const list — no rebuild overhead
  final List<Widget> screens = const [
    HomeScreen(),
    ExploreScreen(),
    Orderbagscreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkIfBlocked();   // ✅ check on every app open
    _listenForBlock();   // ✅ realtime kick when admin blocks
  }

  @override
  void dispose() {
    _blockChannel?.unsubscribe();
    super.dispose();
  }

  Future<void> _checkIfBlocked() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final userData = await supabase
          .from('users')
          .select('blocked')
          .eq('id', userId)
          .single();

      if (userData['blocked'] == true) {
        await supabase.auth.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account has been blocked by the admin'),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Block check error: $e');
    }
  }

  void _listenForBlock() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    _blockChannel = supabase
        .channel('block_check_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (payload) async {
            final blocked = payload.newRecord['blocked'] == true;
            if (blocked) {
              await supabase.auth.signOut();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your account has been blocked'),
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context)
                .bottomNavigationBarTheme
                .backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: const Color(0xFF5DA9E9),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: 'Bestsellers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}