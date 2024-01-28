import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../error_handling.dart';
import '../info_handling.dart';
import '../model/ReservationModel.dart';
import '../theme/color.dart';
import '../utils/data.dart';
import '../widgets/custom_image.dart';
import '../widgets/favorite_box.dart';
import '../widgets/feature_item.dart';

class ReservationWidget extends FeatureItem{
  final Reservation reservation;

  final Function() reservationUpdate;
  ReservationWidget(this.reservation, this.reservationUpdate, {super.key, required super.data});


  @override
  ReservationWidgetState createState() => ReservationWidgetState();

}

class ReservationWidgetState extends State<ReservationWidget>{

  @override
  void initState() {
    super.initState();
  }

  Widget _buildImage() {
    return CustomImage(
      RoomTypeDefaultImage[widget.data.type]!,
      width: double.infinity,
      height: 190,
      radius: 15,
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Container(
              width: widget.width - 20,
              //padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildName(),
                  SizedBox(
                    height: 5,
                  ),
                  _buildInfo(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(visible: widget.reservation.reservationStatus!=ReservationStatus.CANCELED,child: Text("At ${widget.reservation.checkInDate}")),
                        Visibility(visible: widget.reservation.reservationStatus!=ReservationStatus.CANCELED,child: Text("${widget.reservation.numberOfNights} nights"))]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Visibility(
                        visible: widget.reservation.reservationStatus==ReservationStatus.REGISTERED,
                        child: ElevatedButton(onPressed: (){
                          confirmReservation();
                        }, child: Text('Confirm')),
                      ),
                        Visibility(
                          visible: widget.reservation.reservationStatus!=ReservationStatus.CANCELED,
                          child: ElevatedButton(onPressed: (){
                            cancelReservation();
                          }, child: Text('Cancel')),
                        ),
                        Visibility(
                          visible: widget.reservation.reservationStatus==ReservationStatus.CANCELED,
                          child: Text('Cancelled', style: TextStyle(
                            color: Colors.red, // Set the color of the text
                            fontSize: 24, // Set the font size if needed
                            fontWeight: FontWeight.bold, // Set the font weight if needed
                          )),
                        )],
                      )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildName() {
    return Text(
      widget.data.type,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 18,
        color: AppColor.textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.type,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColor.labelColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "${widget.reservation.totalAmount.toString()}£",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColor.primary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Visibility(
          visible: false,
          child: FavoriteBox(
            size: 16,
            onTap: widget.onTapFavorite,
            isFavorited: false,
          ),
        ),

      ],
    );
  }

  Widget _buildMore() {
    return ElevatedButton(onPressed: (){

    }, child: Text('Confirmer'));
  }

  void confirmReservation() async {

    final response = await http.get(Uri.parse('http://localhost:8080/reservations/${widget.reservation.id}/confirm'));
    if (response.statusCode == 200) {
      setState(() {
        widget.reservationUpdate();
        showInfoDialog("Reservaiton confirmed", context);

      });
    } else {
      showErrorDialog('Failed to confirm reservation, please check your wallet, you must have upper than ${widget.reservation.totalAmount/2}£', context);
    }
  }

  void cancelReservation() async {

    final response = await http.get(Uri.parse('http://localhost:8080/reservations/${widget.reservation.id}/cancel'));
    if (response.statusCode == 200) {
      setState(() {
          widget.reservationUpdate();
          showInfoDialog("resrvation cancelled", context);
      });
    } else {
      showErrorDialog('impossible to cancel the reservation', context);
    }
  }
}