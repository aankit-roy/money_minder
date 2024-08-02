import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_minder/res/colors/color_palette.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Define the list of items with titles and icons
  final List<Map<String, dynamic>> items = [
    {'title': 'Recommend to friends', 'icon': Icons.thumb_up_alt_sharp},
    {'title': 'Rate us', 'icon': Icons.star_rate},
    {'title': 'Check for updates', 'icon': Icons.update},
    {'title': 'Privacy Policy', 'icon': Icons.lock},
    {'title': 'Contact us', 'icon': Icons.contact_mail},
  ];


  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.sizeOf(context);
    return Scaffold(
      body:Stack(
        children: [
          ProfileBackground(size: size),
          ProfileDetailsCard(size: size, items: items)
        ],
      )
    );
  }
}

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({
    super.key,
    required this.size,
    required this.items,
  });

  final Size size;
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),

        ),

        child: SizedBox(

          height: size.height*.5,
          width: size.width*.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    final item= items[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        leading: Icon(item['icon'], color: Colors.blue),
                        title: Text(item['title']),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: (){

                          // if (item['title'] == 'Recommend to friends') {
                          //   // Share app link
                          //   final appLink = 'https://play.google.com/store/apps/details?id=com.ankitkumar.quotebook&hl=en'; // Replace with your app's Play Store URL
                          //   // Or use the App Store URL for iOS
                          //   // final appLink = 'https://apps.apple.com/app/idYOUR_APP_ID'; // Replace with your app's App Store URL
                          //   Share.share('Check out this amazing app: $appLink');
                          // }
                          // Handle other ListTile taps if needed

                        },

                      ),
                    );

                  },


                ),
              )





            ],
          ),



        ),
      ),
    );
  }
}

class ProfileBackground extends StatelessWidget {
  const ProfileBackground({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height*.38,
      decoration: const BoxDecoration(
        color: ColorsPalette.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(180)),
      ),

    );
  }
}


