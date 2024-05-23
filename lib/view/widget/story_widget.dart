import 'package:flutter/material.dart';

class StoryWidget extends StatefulWidget {
  const StoryWidget({Key? key}) : super(key: key);

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column( 
      children: [
        Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF9B2282), Color(0xFFEEA863)])),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://instagram.fsgn2-3.fna.fbcdn.net/v/t51.2885-15/281344708_686811312431550_1814185848231468945_n.jpg?stp=dst-webp_e35_p1080x1080&cb=9ad74b5e-be52112b&_nc_ht=instagram.fsgn2-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=8E9BOnQ-JZMAX_SqRAh&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=Mjg0MDEwMTEyODEyNzcxMzkwMQ%3D%3D.2-ccb7-5&oh=00_AT-vXrNeSeI0LJTrv-WVCw4CKuwh5y9IpYLMhpsHhZO1zw&oe=62974679&_nc_sid=30a2ef',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const SizedBox(
              width: 70,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'iam.iat',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
