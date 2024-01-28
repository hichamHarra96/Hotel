import 'package:flutter/material.dart';
import 'package:hotelfront/theme/color.dart';
import 'package:hotelfront/widgets/favorite_box.dart';
import '../model/RoomModel.dart';
import '../utils/data.dart';
import 'custom_image.dart';

class FeatureItem extends StatefulWidget {
  const FeatureItem({
    Key? key,
    required this.data,
    this.width = 280,
    this.height = 300,
    this.onTap,
    this.onTapFavorite,
  }) : super(key: key);

  final Room data;
  final double width;
  final double height;
  final GestureTapCallback? onTapFavorite;
  final GestureTapCallback? onTap;


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FeatureItemState();
  }
}

class FeatureItemState extends State<FeatureItem> {

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
              widget.data.pricePerNight.toString(),
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
        _buildMore()
      ],
    );
  }

  Widget _buildMore() {
    return Container();
  }

}
