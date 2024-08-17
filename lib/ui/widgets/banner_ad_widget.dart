import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_minder/services/Ads_Services/admob_services.dart';

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final AdSize adSize;

  const BannerAdWidget({
    Key? key,
    required this.adUnitId,
    required this.adSize,
  }) : super(key: key);


  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false; // Flag to check if the ad is loaded

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true; // Set flag to true when the ad is loaded
          });

        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          setState(() {
            _isAdLoaded = false; // Handle ad load failure
          });

        },
        onAdOpened: (Ad ad) {

        },
        onAdClosed: (Ad ad) {

        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _bannerAd?.size.width.toDouble(),
      height: _bannerAd?.size.height.toDouble(),
      alignment: Alignment.center,
      child: _isAdLoaded
          ? AdWidget(ad: _bannerAd!)
          : const CircularProgressIndicator(), // Loading indicator
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Clean up the ad when the widget is disposed
    super.dispose();
  }
}