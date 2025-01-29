import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/all_links.dart';
import 'package:money_minder/ui/widgets/banner_ad_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/Ads_Services/admob_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final InAppReview _inAppReview = InAppReview.instance;

  final AdSize adSize= AdSize.largeBanner;
  final profileBannerAdId= AdmobServices.BANNER_Ad_Unit2;
  final List<Map<String, dynamic>> items2 = [

  {'title': 'Recommend to friends', 'icon': const Icon(Icons.thumb_up_alt_sharp)}];


final List<Map<String, dynamic>> items = [
    {'title': 'Recommend to friends', 'icon': Icons.thumb_up_alt_sharp},
    {'title': 'Rate us', 'icon': Icons.star_rate},
    {'title': 'Check for updates', 'icon': Icons.update},
    {'title': 'Privacy Policy', 'icon': Icons.lock},
    {'title': 'Contact us', 'icon': Icons.contact_mail},
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          ProfileBackground(size: size),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               // Card(
               //   shape: RoundedRectangleBorder(
               //     borderRadius: BorderRadius.circular(12),
               //   ),
               //   child: SizedBox(
               //     height: 60,
               //       width: size.width*.85,
               //   ),
               //
               // ),
              Flexible(
                flex: 5,
                child: ProfileDetailsCard(size: size, items: items, inAppReview: _inAppReview),
              ),

              // Flexible(
              //   flex: 1,
              //   child: BannerAdWidget(adUnitId: profileBannerAdId, adSize: adSize),
              // ),
            ],
          ),

        ],
      ),
    );
  }
}

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({
    super.key,
    required this.size,
    required this.items,
    required this.inAppReview,
  });

  final Size size;
  final List<Map<String, dynamic>> items;
  final InAppReview inAppReview;

  @override
  Widget build(BuildContext context) {
    const appLink= AllUrl.appLink;
    const privacyPolicyUrl= AllUrl.privacyPolicyLink;
    const rateUrl= AllUrl.rateUrl;
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: size.height * .5,
          width: size.width * .85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        leading: Icon(item['icon'], color: Colors.blue),
                        title: Text(item['title']),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: () {
                          if (item['title'] == 'Recommend to friends') {
                           // Replace with your app's Play Store URL
                            Share.share('Check out this amazing app: $appLink');
                          } else if (item['title'] == 'Rate us') {
                            _rateApp(rateUrl);
                          } else if (item['title'] == 'Check for updates') {
                            // Implement update checking if needed
                          } else if (item['title'] == 'Privacy Policy') {

                            _launchURL(privacyPolicyUrl);
                          } else if (item['title'] == 'Contact us') {
                            final contactEmail = 'support@example.com'; // Replace with your contact email
                            _sendEmail(contactEmail);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _rateApp(String rateUrl) async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      // Open app store page if in-app review is not available

      _launchURL(rateUrl);
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Feedback&body=Hello,',
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not send email';
    }
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
      height: size.height * .38,
      decoration: const BoxDecoration(
        color: ColorsPalette.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(180)),
      ),
    );
  }
}