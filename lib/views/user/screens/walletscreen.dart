import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MGWalletScreen extends StatefulWidget {
  const MGWalletScreen({super.key});

  @override
  State<MGWalletScreen> createState() => _MGWalletScreenState();
}

class _MGWalletScreenState extends State<MGWalletScreen> {
  final supabase = Supabase.instance.client;

  bool loading = true;
  double balance = 0.0;
  List<Map<String, dynamic>> transactions = [];


  RealtimeChannel? _walletChannel;

  @override
  void initState() {
    super.initState();
    loadWallet();
    _subscribeToWallet();
  }

  @override
  void dispose() {
    
    _walletChannel?.unsubscribe();
    super.dispose();
  }

  
  void _subscribeToWallet() {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    _walletChannel = supabase
        .channel('wallet_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'wallets',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: user.id,
          ),
          callback: (payload) {
            
            final newBalance =
                (payload.newRecord['balance'] as num?)?.toDouble() ?? 0.0;
            setState(() => balance = newBalance);
            // Also reload transactions to show new refund entry
            _loadTransactions();
          },
        )
        .subscribe();
  }

  Future<void> loadWallet() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() => loading = false);
      return;
    }

    try {
      final wallet = await supabase
          .from('wallets')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (wallet == null) {
        await supabase.from('wallets').insert({
          'user_id': user.id,
          'balance': 0,
        });
        balance = 0.0;
      } else {
        balance = (wallet['balance'] as num?)?.toDouble() ?? 0.0;
      }

      await _loadTransactions();

      if (!mounted) return;
      setState(() => loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _loadTransactions() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final history = await supabase
          .from('wallet_transactions')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        transactions = List<Map<String, dynamic>>.from(history);
      });
    } catch (e) {
      print('Load transactions error: $e');
    }
  }

  Future<void> addMoney(double amount) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final newBalance = balance + amount;

      await supabase.from('wallets').update({
        'balance': newBalance,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', user.id);

      await supabase.from('wallet_transactions').insert({
        'user_id': user.id,
        'amount': amount,
        'type': 'credit',
        'title': 'Money Added',
        'description': 'Added to MG Wallet',
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Money added to wallet ')),
      );
    
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void showAddMoneySheet() {
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Money',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final amount =
                      double.tryParse(amountController.text.trim()) ?? 0;
                  if (amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter valid amount')),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  addMoney(amount);
                },
                child: const Text('Add Money'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    if (type == 'debit') return Colors.red;
    if (type == 'refund') return Colors.green;
    return Colors.blue;
  }

  IconData _typeIcon(String type) {
    if (type == 'debit') return Icons.arrow_upward;
    if (type == 'refund') return Icons.replay;
    return Icons.arrow_downward;
  }

  String _amountText(Map<String, dynamic> item) {
    final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
    final type = item['type']?.toString() ?? 'credit';
    return type == 'debit'
        ? '- ₹${amount.toStringAsFixed(2)}'
        : '+ ₹${amount.toStringAsFixed(2)}';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MG Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadWallet,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadWallet,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Balance',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '₹${balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: showAddMoneySheet,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Money'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transactions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${transactions.length} total',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (transactions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text('No transactions yet'),
                      ),
                    ),

                  
                  ...transactions.map((item) {
                    final type = item['type']?.toString() ?? 'credit';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              _typeColor(type).withOpacity(0.15),
                          child: Icon(
                            _typeIcon(type),
                            color: _typeColor(type),
                          ),
                        ),
                        title: Text(
                          item['title']?.toString() ?? 'Wallet',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['description']?.toString() ?? ''),
                            Text(
                              _formatDate(item['created_at']?.toString()),
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Text(
                          _amountText(item),
                          style: TextStyle(
                            color: _typeColor(type),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}