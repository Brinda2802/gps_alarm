import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Homescreens/save_alarm_page.dart';
import 'Homescreens/settings.dart';
import 'Map screen page.dart';
import 'Track.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class _AboutState extends State<About> {
  final Uri toLaunch =
  Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
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
  void handleScreenChanged(int index) {
    switch (index) {
      case 0: // Alarm List
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyAlarmsPage()));
        // Replace with your AlarmListPage widget
        break;
      case 1: // Alarm List
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyHomePage()));

        // Replace with your AlarmListPage widget
        break;

      case 2: // Saved Alarms
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Settings())); // Replace with your SavedAlarmsPage widget
        break;
      case 3:
        final RenderBox box = context.findRenderObject() as RenderBox;
        Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
        Share.share(
          'Check out my awesome app: ! Download it from the app store: ',
          subject: 'Share this amazing app!',
          sharePositionOrigin: dummyRect,
        );
        break;
      case 4:

        _launchInBrowser(toLaunch);


        break;
      case 5:

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => About()));

        break;

    }
  }
  @override
  int screenIndex=5;
  Widget build(BuildContext context) {
    final Uri toLaunch =
    Uri(scheme: 'https', host: 'www.google.com');
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(
        onDestinationSelected: (int index) {
          handleScreenChanged(index); // Assuming you have a handleScreenChanged function
        },
        selectedIndex: screenIndex,
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          NavigationDrawerDestination(

            icon: Icon(Icons.alarm_on_outlined), // Adjust size as needed
            label: Text('Saved Alarms'),
            // Set selected based on screenIndex
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.alarm),
            label: Text('Set a Alarm'),
            // Set selected based on screenIndex
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            label: Text('Settings'),
            // Set selected based on screenIndex
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Communicate', // Assuming this is the header
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.share_outlined),
            label: Text('Share'),

            // Set selected based on screenIndex
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.rate_review_outlined),
            label: Text('Rate/Review'),
            // Set selected based on screenIndex
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'App', // Assuming this is the header
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.error_outline_outlined),
            label: Text('About'),
            // Set selected based on screenIndex
          ),
        ],
      ),
      appBar: AppBar(
       // backgroundColor: Color(0xffFFEF9A9A),
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
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text("However, here's a general idea of how you might use Naplarm based on the information provided Download and Install Naplarm: ",style: Theme.of(context).textTheme.titleMedium
              ),
               SizedBox(
                 height: 40,
               ),
               Text(" 1.Set a location: Open the app and choose the desired destination for your map.\n \n 2.Pick Your Wake Up Style: Select a calming sound or vibration to wake you up gently at the end of your nap.\n  \n 3.Set Location-Based Reminder (Android Only): If you're using GPSalarm on Android and want a nap reminder based on your location,\nenable location services within the app and enter your destination.\n \n 4.For any remarks or support contact support@Qsyss.com",textAlign: TextAlign.left,
                 style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
        ),
      ),
    );
  }
}
