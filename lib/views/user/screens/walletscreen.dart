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

  @override
  void initState() {
    super.initState();
    loadWallet();
  }

  Future<void> loadWallet() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() {
        loading = false;
      });
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

      final history = await supabase
          .from('wallet_transactions')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        transactions = List<Map<String, dynamic>>.from(history);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> addMoney(double amount) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    try {
      final newBalance = balance + amount;

      await supabase
          .from('wallets')
          .update({
            'balance': newBalance,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.id);

      await supabase.from('wallet_transactions').insert({
        'user_id': user.id,
        'amount': amount,
        'type': 'credit',
        'title': 'Money Added',
        'description': 'Added to MG Wallet',
      });

      if (!mounted) return;

      setState(() {
        balance = newBalance;
      });

      loadWallet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Money added to wallet')),
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
      builder: (_) {
        return Padding(
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
        );
      },
    );
  }

  Color typeColor(String type) {
    if (type == 'debit') return Colors.red;
    if (type == 'refund') return Colors.green;
    return Colors.blue;
  }

  String amountText(Map<String, dynamic> item) {
    final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
    final type = item['type']?.toString() ?? 'credit';

    if (type == 'debit') {
      return '- ₹${amount.toStringAsFixed(2)}';
    }

    return '+ ₹${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MG Wallet'),
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
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
                        ElevatedButton(
                          onPressed: showAddMoneySheet,
                          child: const Text('Add Money'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: typeColor(type).withOpacity(0.15),
                          child: Icon(
                            type == 'debit'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: typeColor(type),
                          ),
                        ),
                        title: Text(item['title']?.toString() ?? 'Wallet'),
                        subtitle: Text(
                          item['description']?.toString() ?? '',
                        ),
                        trailing: Text(
                          amountText(item),
                          style: TextStyle(
                            color: typeColor(type),
                            fontWeight: FontWeight.bold,
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