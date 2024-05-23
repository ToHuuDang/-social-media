import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hoạt động',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
           Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mới',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
           SizedBox(
              height: 10,
            ),
            Row(
              children:[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://instagram.fsgn2-3.fna.fbcdn.net/v/t51.2885-15/281344708_686811312431550_1814185848231468945_n.jpg?stp=dst-webp_e35_p1080x1080&cb=9ad74b5e-be52112b&_nc_ht=instagram.fsgn2-3.fna.fbcdn.net&_nc_cat=106&_nc_ohc=beo7CNfBOqQAX-xiOwo&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=Mjg0MDEwMTEyODEyNzcxMzkwMQ%3D%3D.2-ccb7-5&oh=00_AT-USFHBSneQn5O9C10yTt0LTLbJJIX0O6L8UDdsYUB9kg&oe=62A129B9&_nc_sid=30a2ef'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('Băng Dương đã thích ảnh của bạn'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
