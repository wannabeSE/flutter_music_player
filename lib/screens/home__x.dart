import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/dummy_data/popular_artist.dart';
import 'package:get/get.dart';

class HomeX extends StatelessWidget {
  const HomeX({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = Get.width;
    double borderRadius = deviceWidth * 0.1;
    borderRadius = borderRadius.clamp(10, 30);
    double generalPadding = deviceWidth * 0.04;
    generalPadding = generalPadding.clamp(10, 14);
    double contentPadding = deviceWidth * 0.02;
    contentPadding = contentPadding.clamp(10, 15);

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraint){
          return Container(
            decoration: TColor.gradientBg,
            child: Padding(
              padding: EdgeInsets.all(generalPadding),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: generalPadding, bottom: generalPadding),
                    child: SizedBox(
                      height: Get.height * 0.06,
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search for songs...',
                          suffixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(top: contentPadding, left: contentPadding),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: BorderSide.none
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Popular Artists',
                    style: TextStyle(
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: generalPadding,),
                  SizedBox(
                    height: constraint.maxWidth > 640 ? Get.height * 0.3 : Get.height * 0.25,
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
          );
          }
        ),
      ),
    );
  }
}

class ArtistCard extends StatelessWidget {
  final int index;

  const ArtistCard({
    super.key,
    required this.index
  });
  @override
  Widget build(BuildContext context) {
    double deviceWidth = Get.width;

    return LayoutBuilder(
      builder: (context, constraint) =>
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                right: constraint.maxWidth < 640 ? 4 : 8,
                bottom: constraint.maxWidth < 640 ? 2 : 4
            ),
            height: Get.height * 0.18,
            width: constraint.maxWidth < 640 ? deviceWidth * 0.2 : deviceWidth * 0.35,
            //color: Colors.blue,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(popularArtist[index]['img']), //dummy data
                    fit: BoxFit.cover
                ),
              borderRadius: BorderRadius.circular(16)
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.3,
            child: Text(popularArtist[index]['name'],
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: constraint.maxWidth < 640 ? 10 : 12,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Text('${popularArtist[index]['songCount']} songs',
            style: TextStyle(
              fontSize: constraint.maxWidth < 640 ? 8 : 10
            ),
          )
        ],
      ),
    );
  }
}
