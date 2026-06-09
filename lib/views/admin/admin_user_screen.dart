import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Adminuserscreen extends StatefulWidget {
  const Adminuserscreen({super.key});

  @override
  State<Adminuserscreen> createState() => _AdminuserscreenState();
}

class _AdminuserscreenState extends State<Adminuserscreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .neq('role', 'admin')
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        users = List<Map<String, dynamic>>.from(response);
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = users.where((user) {
        final name = (user['name'] ?? '').toLowerCase();
        final email = (user['email'] ?? '').toLowerCase();
        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteUser(String id) async {
    try {
      await supabase.from('users').delete().eq('id', id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      await fetchUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> toggleUserStatus(String id, bool currentStatus) async {
    try {
      await supabase
          .from('users')
          .update({'blocked': !currentStatus})
          .eq('id', id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !currentStatus ? 'User blocked' : 'User unblocked',
          ),
        ),
      );
      await fetchUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  
  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return 'Unknown';
    }
  }

  String _getInitials(Map<String, dynamic> user) {
    final name = user['name']?.toString().trim();
    if (name != null && name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    final email = user['email']?.toString() ?? '';
    return email.isNotEmpty ? email[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = users.where((u) => u['blocked'] != true).length;
    final blockedCount = users.where((u) => u['blocked'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUsers,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      _statPill(
                        '${users.length} Total',
                        Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _statPill(
                        '$activeCount Active',
                        Colors.green,
                      ),
                      const SizedBox(width: 8),
                      _statPill(
                        '$blockedCount Blocked',
                        Colors.red,
                      ),
                    ],
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                
                Expanded(
                  child: filteredUsers.isEmpty
                      ? const Center(child: Text('No users found'))
                      : RefreshIndicator(
                          onRefresh: fetchUsers,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              final blocked = user['blocked'] == true;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      
                                      Row(
                                        children: [
                                          // Avatar with initials
                                          CircleAvatar(
                                            radius: 26,
                                            backgroundColor: blocked
                                                ? Colors.red.shade100
                                                : Colors.blue.shade100,
                                            child: Text(
                                              _getInitials(user),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: blocked
                                                    ? Colors.red.shade700
                                                    : Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user['name'] ?? 'No name',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  user['email'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: blocked
                                                  ? Colors.red.shade50
                                                  : Colors.green.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              blocked ? 'Blocked' : 'Active',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: blocked
                                                    ? Colors.red.shade700
                                                    : Colors.green.shade700,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            size: 14,
                                            color: Colors.grey.shade500,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            
                                            'Joined: ${_formatDate(user['created_at']?.toString())}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 14),

                                    
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: blocked
                                                    ? Colors.green
                                                    : Colors.red,
                                                side: BorderSide(
                                                  color: blocked
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              icon: Icon(
                                                blocked
                                                    ? Icons.lock_open
                                                    : Icons.block,
                                                size: 16,
                                              ),
                                              label: Text(
                                                blocked
                                                    ? 'Unblock'
                                                    : 'Block',
                                              ),
                                              onPressed: () =>
                                                  toggleUserStatus(
                                                user['id'],
                                                blocked,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.red,
                                                side: const BorderSide(
                                                  color: Colors.red,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                size: 16,
                                              ),
                                              label: const Text('Delete'),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        'Delete User'),
                                                    content: Text(
                                                      'Delete "${user['name'] ?? user['email']}"? This cannot be undone.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          await deleteUser(
                                                              user['id']);
                                                        },
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color: Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _statPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}