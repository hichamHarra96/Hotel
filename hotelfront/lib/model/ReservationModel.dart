import 'package:hotelfront/model/ClientModel.dart';
import 'package:hotelfront/model/RoomModel.dart';

class Reservation {
  final String id;
  final RoomClient client;
  final Room room;
  final ReservationStatus reservationStatus;
  final String checkInDate;
  final int numberOfNights;
  final int totalAmount;

  Reservation({
    this.id='',
    required this.client,
    required this.room,
    required this.reservationStatus,
    required this.checkInDate,
    required this.numberOfNights,
    required this.totalAmount,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      client: RoomClient.fromJson(json['client']),
      room: Room.fromJson(json['room']),
      reservationStatus: getEnumValueFromString(json['status']),
      checkInDate: json['checkInDate'],
      numberOfNights: json['numberOfNights'],
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return ReservationDto(clientEmail: client.email, roomType: room.type, checkInDate: checkInDate, numberOfNights: numberOfNights).toJson();
  }
}

class ReservationDto {
   final String clientEmail;
   final String roomType;
   final String checkInDate;
   final int numberOfNights;

  ReservationDto({required this.clientEmail, required this.roomType, required this.checkInDate, required this.numberOfNights});

   Map<String, dynamic> toJson() {
     return {
     'clientEmail': clientEmail,
     'roomType': roomType,
     'checkInDate': checkInDate,
     'numberOfNights': numberOfNights,
   };
   }
// Getters and setters...
}
enum ReservationStatus {
  REGISTERED,
  CONFIRMED,
  CANCELED
}

ReservationStatus getEnumValueFromString(String stringValue) {
  return ReservationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == stringValue,
    orElse: () => ReservationStatus.REGISTERED,
  );
}
