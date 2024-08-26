import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/responsive.dart';
import 'package:get/get.dart';

import '../../dummy_data/popular_artist.dart';
import 'components/artist_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double generalPadding = 8;
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: const _CustomAppbar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: generalPadding),
                    child: const Text(
                      'Popular Artists',
                      style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      foregroundColor:
                        WidgetStatePropertyAll(Colors.white)
                      ),
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 10
                      ),
                    )
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: generalPadding),
                height: Get.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularArtist.length,
                    itemBuilder: (context, i) =>
                    ArtistCard(
                      index: i,
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppbar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: double.infinity,
      leading: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.orange,
            ),
          ),
          Text(
            'Hi, Samir',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.isMobile(context) ? 12 : 18),
          )
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
              size: Responsive.isMobile(context) ? 24 : 32,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kIsWeb ? 40 : Get.height * 0.09);
}
