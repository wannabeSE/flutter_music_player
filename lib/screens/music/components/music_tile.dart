import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MusicTile extends StatelessWidget {
  final int index;
  final List data;
  const MusicTile({
    super.key,
    required this.index, required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.9,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white38, width: 2))),
      child: Row(
        children: [
          //music cover image
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                  //TODO: Make it Dynamic
                  image: NetworkImage(
                      'https://wallpapers.com/images/high/dreadlocks-kendrick-lamar-mdxg6124r23k078x.webp'),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: Get.width * 0.6,
            margin: const EdgeInsets.only(left: 4, top: 12),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Track title
                SizedBox(
                  width: 100,
                  child: Text(
                    'Music Title',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    'Artist name',
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                )
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/icons/favorite.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: 20,
          ),
          const SizedBox(
            width: 20,
          ),
          SvgPicture.asset(
            'assets/icons/play.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: 16,
          ),
        ],
      ),
    );
  }
}
