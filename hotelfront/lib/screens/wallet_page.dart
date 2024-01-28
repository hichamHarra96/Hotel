
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../error_handling.dart';
import '../model/ClientModel.dart';
import '../model/wallet.dart';

import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  final RoomClient client;

  const WalletPage({super.key, required this.client});
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Wallet myWallet = Wallet(id: "1", balance: 0.0, currency: Currency.EURO);

  @override
  void initState() {
    super.initState();
    fetchWallet();
  }

  Future<void> fetchWallet() async {
    final response = await http.get(Uri.parse('http://localhost:8080/clients/${widget.client.email}/balance/${Currency.EURO.toString().split('.').last}'));
    if (response.statusCode == 200) {
      setState(() {
        myWallet.balance = json.decode(response.body).toDouble();
      });
    } else {
      showErrorDialog('Failed to connect wallet', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance: ${myWallet.balance} ${getCurrencySymbol(myWallet.currency)}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMoneyPage(myWallet: myWallet, client:widget.client)),
                );
              },
              child: Text('Add Money'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                fetchWallet();
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  String getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.EURO:
        return '€';
      case Currency.DOLLAR:
        return '\$';
      case Currency.POUND_STERLING:
        return '£';
      case Currency.YEN:
        return '¥';
      case Currency.SWISS_FRANC:
        return 'CHF';
    }
  }
}

class AddMoneyPage extends StatefulWidget {
  final Wallet myWallet;
  final RoomClient client;
  const AddMoneyPage({Key? key, required this.myWallet, required this.client}) : super(key: key);

  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  TextEditingController amountController = TextEditingController();
  Currency selectedCurrency = Currency.EURO;

  Future<void> increaseBalance() async {
    final response = await http.get(Uri.parse('http://localhost:8080/clients/${widget.client.email}/credit/${int.tryParse(amountController.text) ?? 0.0}/${selectedCurrency.toString().split('.').last}'));
    if (response.statusCode == 201) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      showErrorDialog('Impossible to increase the wallet', context);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Balance: ${widget.myWallet.balance} ${getCurrencySymbol(widget.myWallet.currency)}'),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              value: selectedCurrency,
              items: Currency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(getCurrencyName(currency)),
                );
              }).toList(),
              onChanged: (Currency? value) {
                setState(() {
                  selectedCurrency = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Currency',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount>0){

                  setState(() {
                    widget.myWallet.balance += amount;
                    increaseBalance();
                  });
                }else{
                  showErrorDialog("Please give a correct amount!", context);
                }
              },
              child: Text('Add Money'),
            ),
          ],
        ),
      ),
    );
  }

  String getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.EURO:
        return '€';
      case Currency.DOLLAR:
        return '\$';
      case Currency.POUND_STERLING:
        return '£';
      case Currency.YEN:
        return '¥';
      case Currency.SWISS_FRANC:
        return 'CHF';
    }
  }

  String getCurrencyName(Currency currency) {
    switch (currency) {
      case Currency.EURO:
        return 'Euro';
      case Currency.DOLLAR:
        return 'Dollar';
      case Currency.POUND_STERLING:
        return 'Pound Sterling';
      case Currency.YEN:
        return 'Yen';
      case Currency.SWISS_FRANC:
        return 'Swiss Franc';
    }
  }
}