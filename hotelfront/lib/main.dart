import 'package:flutter/material.dart';
import 'package:hotelfront/screens/client_entry_page.dart';
import 'screens/root_app.dart';
import 'theme/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Booking',
      theme: ThemeData(
        primaryColor: AppColor.primary,
      ),
      home: ClientEntryPage(),
    );
  }
}
