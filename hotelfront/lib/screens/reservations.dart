


import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotelfront/info_handling.dart';
import 'package:hotelfront/model/ReservationModel.dart';
import 'package:hotelfront/screens/reservation_widget.dart';

import '../error_handling.dart';
import '../model/ClientModel.dart';
import '../model/wallet.dart';

import 'package:http/http.dart' as http;

import '../widgets/feature_item.dart';

class ReservationPage extends StatefulWidget {
  final RoomClient client;

  const ReservationPage({super.key, required this.client});
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List <Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    final response = await http.get(Uri.parse('http://localhost:8080/clients/${widget.client.email}/reservations'));
    if (response.statusCode == 200) {
      setState(() {

        List<dynamic> reservationsJson = json.decode(response.body);
        reservations = List<Reservation>.generate(reservationsJson.length, (index) => Reservation.fromJson(reservationsJson[index]));
        if (reservations.isEmpty){
          showInfoDialog("No reservation for the moment for you", context);
        }
      });
    } else {
      showErrorDialog('Failed list reservations', context);
    }
  }

  _buildFeatured() {
    return CarouselSlider(
      options: CarouselOptions(
          height: 490,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .75,
          scrollDirection: Axis.vertical
      ),
      items: List.generate(
        reservations.length,
            (index) => ReservationWidget(
              reservations[index],
              (){
                fetchReservations();
              },
            data: reservations[index].room,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeatured(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                fetchReservations();
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

}