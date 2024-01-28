
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelfront/theme/color.dart';
import 'package:hotelfront/utils/data.dart';
import 'package:hotelfront/widgets/custom_image.dart';
import 'package:hotelfront/widgets/icon_box.dart';
import 'package:hotelfront/widgets/setting_item.dart';

import '../model/ClientModel.dart';
import 'client_entry_page.dart';

class SettingPage extends StatefulWidget {
  final RoomClient client;
  const SettingPage({Key? key, required this.client}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
            title: _buildAppBar(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBody(),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Settings",
            style: TextStyle(
              color: AppColor.textColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Visibility(
          visible: false,
          child: IconBox(
            child: SvgPicture.asset(
              "assets/icons/edit.svg",
              width: 18,
              height: 18,
            ),
            bgColor: AppColor.appBgColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(right: 20, top: 10),
      child: Column(
        children: [
          _buildProfile(),
          /*const SizedBox(height: 40),
          SettingItem(
            title: "General Setting",
            leadingIcon: Icons.settings,
            leadingIconColor: AppColor.orange,
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: "Bookings",
            leadingIcon: Icons.bookmark_border,
            leadingIconColor: AppColor.blue,
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: "Favorites",
            leadingIcon: Icons.favorite,
            leadingIconColor: AppColor.red,
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: "Privacy",
            leadingIcon: Icons.privacy_tip_outlined,
            leadingIconColor: AppColor.green,
          ),*/
          const SizedBox(height: 10),
          SettingItem(
            title: "Log Out",
            leadingIcon: Icons.logout_outlined,
            leadingIconColor: Colors.grey.shade400,
            onTap: () {
              _showConfirmLogout();
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        children: <Widget>[
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
          const SizedBox(
            height: 12,
          ),
          Text(
            widget.client.fullName,
            style: TextStyle(
              color: AppColor.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.client.phoneNumber,
            style: TextStyle(
              color: AppColor.labelColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  _showConfirmLogout() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text("Would you like to log out?"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ClientEntryPage()),
              );
            },
            child: Text(
              "Log Out",
              style: TextStyle(color: AppColor.actionColor),
            ),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
