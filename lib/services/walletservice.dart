import 'package:supabase_flutter/supabase_flutter.dart';

class WalletService {

  final supabase = Supabase.instance.client;

  /// FETCH WALLET BALANCE
  Future<double> fetchWalletBalance() async {

    try {

      final user = supabase.auth.currentUser;

      // USER NOT LOGGED IN
      if (user == null) {

        print("User not logged in");

        return 0;
      }

      print("USER ID: ${user.id}");

      // FETCH WALLET
      final response = await supabase
          .from('wallets')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      print("WALLET RESPONSE: $response");

      // WALLET NOT FOUND
      if (response == null) {

        print("Wallet not found, creating new wallet...");

        await supabase.from('wallets').insert({

          "user_id": user.id,
          "balance": 0,

        });

        return 0;
      }

      // RETURN BALANCE
      return (response['balance'] ?? 0).toDouble();

    } catch (e) {

      print("WALLET ERROR: $e");

      return 0;
    }
  }

  /// ADD MONEY TO WALLET
  Future<void> addMoney(double amount) async {

    try {

      final user = supabase.auth.currentUser;

      if (user == null) return;

      final wallet = await supabase
          .from('wallets')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (wallet == null) return;

      double currentBalance =
          (wallet['balance'] ?? 0).toDouble();

      double updatedBalance =
          currentBalance + amount;

      await supabase
          .from('wallets')
          .update({
            "balance": updatedBalance,
          })
          .eq('user_id', user.id);

      print("Money Added Successfully");

    } catch (e) {

      print("ADD MONEY ERROR: $e");
    }
  }

  /// DEDUCT MONEY
  Future<void> deductMoney(double amount) async {

    try {

      final user = supabase.auth.currentUser;

      if (user == null) return;

      final wallet = await supabase
          .from('wallets')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (wallet == null) return;

      double currentBalance =
          (wallet['balance'] ?? 0).toDouble();

      double updatedBalance =
          currentBalance - amount;

      await supabase
          .from('wallets')
          .update({
            "balance": updatedBalance,
          })
          .eq('user_id', user.id);

      print("Money Deducted Successfully");

    } catch (e) {

      print("DEDUCT MONEY ERROR: $e");
    }
  }
}