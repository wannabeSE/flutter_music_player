import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dummy_data/popular_artist.dart';

class ArtistCard extends StatelessWidget {
  final int index;

  const ArtistCard({
    super.key,
    required this.index
  });
  @override
  Widget build(BuildContext context) {
    double deviceWidth = Get.width;
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Container(
         margin: const EdgeInsets.only(
             right: 8,
             bottom: 2
         ),
         height: 140,
         width: 140,
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
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 10,
            fontWeight: FontWeight.w600
          ),
        ),
       ),
       Text('${popularArtist[index]['songCount']} songs',
         style: const TextStyle(
           fontSize: 8
         ),
       )
     ],
          );
  }
}