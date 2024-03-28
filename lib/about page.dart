import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Homescreens/save alarm pages.dart';
import 'Homescreens/settings.dart';
import 'Track.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class _AboutState extends State<About> {
  double radius=0;
  Future<void>? _launched;
  updateradiusvalue(value){
    setState(() {
      radius=value;
    });
  }
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  @override
  Widget build(BuildContext context) {
    final Uri toLaunch =
    Uri(scheme: 'https', host: 'www.google.com');
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Image.asset("assets/mapimage.png",height: 100,width: 100,),
                Text('GPS ALARM',style: TextStyle(
                  color: CupertinoColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),),
              ],
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.track_changes),
              title: Text('Alarm List'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>Track())
                );
                // Handle item 1 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Set a alarm'),
              onTap: () {
                Navigator.of(context).pop();
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm_on_outlined),
              title: Text('Saved Alarm'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>
                        MyAlarmsPage(


                        )));
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>Settings())
                );
                // Handle item 2 tap
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('Communicate',style: TextStyle(
                color: Colors.orange,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () async {
                final RenderBox box = context.findRenderObject() as RenderBox;
                Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
                Share.share(
                  'Check out my awesome app: ! Download it from the app store: ',
                  subject: 'Share this amazing app!',
                  sharePositionOrigin: dummyRect,
                );
              },
            ),
            // Row(
            //   children: [
            //     IconButton(
            //       icon: Icon(Icons.share),
            //       onPressed: () async {
            //         final RenderBox box = context.findRenderObject() as RenderBox;
            //         Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
            //         Share.share(
            //           'Check out my awesome app: ! Download it from the app store: ',
            //           subject: 'Share this amazing app!',
            //           sharePositionOrigin: dummyRect,
            //         );
            //       },
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     InkWell(
            //       onTap: () async {
            //         final RenderBox box = context.findRenderObject() as RenderBox;
            //         Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
            //         Share.share(
            //           'Check out my awesome app: ! Download it from the app store: ',
            //           subject: 'Share this amazing app!',
            //           sharePositionOrigin: dummyRect,
            //         );
            //       },
            //       child: Text("Share",style: TextStyle(
            //         fontWeight: FontWeight.w400,
            //         fontSize: 16,
            //
            //       ),),
            //     ),
            //   ],
            // ),

            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                setState(() {
                  _launched = _launchInBrowser(toLaunch);
                });
                // _launchInBrowser(toLaunch);
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Rate/Review'),
              onTap: () {
                setState(() {
                  _launched = _launchInBrowser(toLaunch);
                });
                // Handle item 2 tap
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('App',style: TextStyle(
                color: Colors.orange,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),),
            ),
            ListTile(
              leading: Icon(Icons.error),
              title: Text('About'),
              onTap: () {
                Navigator.of(context).pop();
                // Handle item 2 tap
              },
            ),

            // Add more list items as needed
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: Color(0xffFFEF9A9A),
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: (){
              _scaffoldKey.currentState?.openDrawer();
            },


            child: Icon(Icons.menu,size: 25,color: Colors.black,)),
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
         "About",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.black,
            ),
              borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text("However, here's a general idea of how you might use Naplarm based on the information provided Download and Install Naplarm: ",style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Colors.black,
              ),),
               SizedBox(
                 height: 40,
               ),
               Text("      1.Set a Nap Time: Open the app and choose the desired duration for your nap.\n \n      2.Pick Your Wake Up Style: Select a calming sound or vibration to wake you up gently at the end of your nap.\n  \n     3.Set Location-Based Reminder (Android Only): If you're using Naplarm on Android and want a nap reminder based on your location,\nenable location services within the app and enter your destination.",textAlign: TextAlign.left,
                 style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.black38,
              ),),
            ],
          ),
        ),
      ),

    );
  }
}
