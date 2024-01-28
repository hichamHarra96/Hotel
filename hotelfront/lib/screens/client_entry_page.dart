
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotelfront/screens/root_app.dart';

import '../error_handling.dart';
import '../model/ClientModel.dart';

class ClientEntryPage extends StatefulWidget {
  @override
  _ClientEntryPageState createState() => _ClientEntryPageState();
}

class _ClientEntryPageState extends State<ClientEntryPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  Future<void> createClient(RoomClient clientToCreate) async {
    try {
      // Attempt to parse the user input as an integer
      //dynamic result = await http.get(Uri.parse('http://localhost:8081/clients'),
      //    headers: {'Content-Type': 'application/json'}); 10.0.2.2

      final response = await http.post(Uri.parse('http://localhost:8080/clients'),
          headers:{
            'Content-Type': 'application/json',
            'Accept': '*/*',
          },
          body: jsonEncode(clientToCreate.toJson())
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RootApp(client:RoomClient.fromJson(json.decode(response.body)))),
        );
        setState(() {});
      } else {

        showErrorDialog('Failed to connect client', context);
        throw Exception('Failed to connect client');
      }

      fullNameController.clear();
      emailController.clear();
      phoneNumberController.clear();

    } catch (e) {
      // Handle the exception (e.g., invalid input)

      showErrorDialog('Error: $e', context);
      print('Error: $e');
    } finally {
      // This block will always run
      print('Finished handling exception');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
    padding: EdgeInsets.only(right: 20, top: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50.0, // Adjust the radius to set the size of the circle
                  backgroundColor: Colors.blue, // Set the background color of the circle
                  child: Icon(
                    Icons.person,
                    size: 60.0, // Adjust the size of the user icon
                    color: Colors.white, // Set the color of the user icon
                  ),
                ),
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 16),
              Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate and save client information
                    final String fullName = fullNameController.text;
                    final String email = emailController.text;
                    final String phoneNumber = phoneNumberController.text;

                    if (fullName.isNotEmpty && email.isNotEmpty && phoneNumber.isNotEmpty) {
                      // Perform some action with the client information, e.g., connect
                      createClient(RoomClient(
                        fullName: fullName,
                        email: email,
                        phoneNumber: phoneNumber,
                      ));
                    } else {
                      // Show an error message or handle empty fields
                      print('Please fill in all fields.');
                    }
                  },
                  child: Text('Connect'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}