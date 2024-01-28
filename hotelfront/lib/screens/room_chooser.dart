import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:http/http.dart' as http;
import '../error_handling.dart';
import '../info_handling.dart';
import '../model/ClientModel.dart';
import '../model/ReservationModel.dart';
import '../model/RoomModel.dart';
import '../widgets/feature_item.dart';
import 'calendar_range_chooser.dart';


class RoomChooserPage extends StatelessWidget {
  final RoomClient client;
  final Room choosenRoom;
  Reservation? reservation;
  RoomChooserPage({super.key, required this.choosenRoom, required this.client});

  Future<void> bookARoom(Reservation reservationToBook, context) async {
    try {
      // Attempt to parse the user input as an integer
      //dynamic result = await http.get(Uri.parse('http://localhost:8081/clients'),
      //    headers: {'Content-Type': 'application/json'}); 10.0.2.2

      final response = await http.post(Uri.parse('http://localhost:8080/reservations'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json",
            "Accept": "*/*"
          },
          body: jsonEncode(reservationToBook.toJson())
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        showInfoDialog("Room ${choosenRoom.type} booked", context);
        //Navigator.pop(context);
      } else {
        showErrorDialog('Failed to book the room, please check your wallet, you must have upper than ${reservationToBook.totalAmount}£', context);
      }

    } catch (e) {
      // Handle the exception (e.g., invalid input)
      print('Error: $e');
      showErrorDialog('Error: $e', context);
    } finally {
      // This block will always run
      print('Finished handling exception');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a room'),
      ),
      body: SingleChildScrollView(
    padding: EdgeInsets.only(right: 20, top: 10),
    child: Center(
        child: Column(
          children:[
            FeatureItem(
              data: choosenRoom,
              onTapFavorite: () {

              },
            ),
            ReservationRangeChooser(onReservationDateRangeChanged: (Map<String, dynamic>? checkinDateAndNumberOfNights) {
              reservation = checkinDateAndNumberOfNights!=null?Reservation(client: client, room: choosenRoom, checkInDate: checkinDateAndNumberOfNights!['checkInDate'], numberOfNights: checkinDateAndNumberOfNights['numberOfNights'], reservationStatus: ReservationStatus.REGISTERED, totalAmount:((checkinDateAndNumberOfNights['numberOfNights']*choosenRoom.pricePerNight)/2).toInt()):null;
            },),
            ElevatedButton(
              onPressed: () async {
                if (reservation==null){
                  showInfoDialog("Please select a range of nights", context);
                }else{
                  await bookARoom(reservation!, context);
                  print(reservation?.toJson());
                }
              },
              child: Text('Book the room'),
            )
          ]
        ),
      )),
    );
  }


}
