import 'package:flutter/material.dart';
import 'package:hotelfront/model/ClientModel.dart';
import 'package:hotelfront/screens/reservations.dart';
import 'package:hotelfront/screens/setting.dart';
import 'package:hotelfront/screens/wallet_page.dart';
import 'package:hotelfront/theme/color.dart';
import 'package:hotelfront/utils/constant.dart';
import 'package:hotelfront/widgets/bottombar_item.dart';

import 'home.dart';

class RootApp extends StatefulWidget {
  final RoomClient client;
  const RootApp({Key? key, required this.client}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState(client);
}

class _RootAppState extends State<RootApp> with TickerProviderStateMixin {
  int _activeTabIndex = 0;
  final List _barItems = [
    {
      "icon": Icons.search_rounded,
      "page": Container(
        alignment: Alignment.center,
        child: Text("Explore"),
      ),
      "visible": false
    },
    {
      "icon": Icons.pin_drop,
      "page": Container(
        alignment: Alignment.center,
        child: Text("Nearby"),
      ),
      "visible": false
    },
  ];

  final RoomClient client;

  _RootAppState(this.client){
    _barItems.insert(0,
      {
        "icon": Icons.home,
        "page": HomePage(client:client),
        "visible": true
      });
    _barItems.add({
      "icon": Icons.book,
      "page": ReservationPage(client:client),
      "visible": true
    });
    _barItems.add({
      "icon": Icons.wallet,
      "page": WalletPage(client:client),
      "visible": true
    });
    _barItems.add({
      "icon": Icons.settings,
      "page": SettingPage(client:client),
      "visible": true
    });
  }
  // ====== set animation=====
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: ANIMATED_BODY_MS),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  _buildAnimatedPage(page) {
    return FadeTransition(child: page, opacity: _animation);
  }

  void onPageChanged(int index) {
    if (index == _activeTabIndex) return;
    _controller.reset();
    setState(() {
      _activeTabIndex = index;
    });
    _controller.forward();
  }

//====== end set animation=====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      bottomNavigationBar: _buildBottomBar(),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _activeTabIndex,
      children: List.generate(
        _barItems.length,
        (index) => Visibility(visible: _barItems[index]['visible'],child: _buildAnimatedPage(_barItems[index]["page"])),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.bottomBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
          bottom: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _barItems.length,
            (index) => Visibility(
              visible: _barItems[index]["visible"],
              child: BottomBarItem(
                _barItems[index]["icon"],
                isActive: _activeTabIndex == index,
                activeColor: AppColor.primary,
                onTap: () => onPageChanged(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
