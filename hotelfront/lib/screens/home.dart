import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hotelfront/screens/room_chooser.dart';
import 'package:hotelfront/theme/color.dart';
import 'package:hotelfront/utils/data.dart';
import 'package:hotelfront/widgets/city_item.dart';
import 'package:hotelfront/widgets/feature_item.dart';
import 'package:hotelfront/widgets/notification_box.dart';
import 'package:hotelfront/widgets/recommend_item.dart';

import 'package:http/http.dart' as http;

import '../model/ClientModel.dart';
import '../model/RoomModel.dart';

class HomePage extends StatefulWidget {
  final RoomClient client;
  const HomePage({Key? key, required this.client}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.appBarColor,
            pinned: true,
            snap: true,
            floating: true,
            title: _builAppBar(),
          ),
          SliverToBoxAdapter(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    rooms = [];
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final response = await http.get(Uri.parse('http://localhost:8080/rooms'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        rooms = data.map((item) => Room.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load rooms');
    }
  }
  Widget _builAppBar() {
    return Visibility(
        visible: false,
        child: Row(
      children: [
        Icon(
          Icons.place_outlined,
          color: AppColor.labelColor,
          size: 20,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          "Phnom Penh",
          style: TextStyle(
            color: AppColor.darker,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        NotificationBox(
          notifiedNumber: 1,
        )
      ],
    ));
  }

  _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Visibility(
        visible: false,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
            child: Text(
              "Find and Book",
              style: TextStyle(
                color: AppColor.labelColor,
                fontSize: 14,
              ),
            ),
          )),
    Visibility(
    visible: false,
    child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "The Best Hotel Rooms",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          )),
          Visibility(
          visible: false,
          child: _buildCities()),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "Rooms",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
          ),
          _buildFeatured(),
          const SizedBox(
            height: 15,
          ),
          Visibility(
            visible: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textColor),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(fontSize: 14, color: AppColor.darker),
                  ),
                ],
              ),
            ),
          ),
                Visibility(
    visible: false,
    child: _getRecommend())
        ],
      ),
    );
  }

  _buildFeatured() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: true,
        disableCenter: true,
        viewportFraction: .75,
      ),
      items: List.generate(
        rooms.length,
        (index) => InkWell(
          onTap: (){

            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RoomChooserPage(choosenRoom: rooms[index],client:widget.client)),
            );

          },
          child: FeatureItem(
            data: rooms[index],
            onTapFavorite: () {
              setState(() {
                features[index]["is_favorited"] =
                    !features[index]["is_favorited"];
              });
            },
          ),
        ),
      ),
    );
  }

  _getRecommend() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          recommends.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: RecommendItem(
              data: recommends[index],
            ),
          ),
        ),
      ),
    );
  }

  _buildCities() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15, 5, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          cities.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CityItem(
              data: cities[index],
            ),
          ),
        ),
      ),
    );
  }
}
