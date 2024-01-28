enum Currency {
  EURO,
  DOLLAR,
  POUND_STERLING,
  YEN,
  SWISS_FRANC,
}

class Wallet {
  String id;
  double balance;
  Currency currency;

  Wallet({this.id='',required this.balance, required this.currency});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      balance: json['balance'],
      currency: json['currency'],
    );
  }
// You can add additional methods or properties as needed
}
